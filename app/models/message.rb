class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  attr_reader :key

  belongs_to :chat

  validates_uniqueness_of :number, scope: :chat_id
  validates :content, presence: true

  after_initialize :get_number

  before_validation :remove_whitespaces

  def remove_whitespaces
    self.content.strip!
  end

  def key
    @key = "messages:#{self.chat.id}"
  end

  def respect_counters
    self.chat.increment(:messages_count)
    self.chat.save!
  end

  def get_number
    if self.number == 0
      entry = $redis.get(key)

      if entry.nil?
        self.number = 1
      else
        count = Integer(entry)
        count += 1
        self.number = count
      end
    else
      self.number
    end
  end

  def assign_number
    self.get_number
    $redis.set(key, self.number.to_s)
  end

  def self.search_content(app_token, chat_number, query)
    response = self.search({
                             query:
                               {
                                 bool:
                                   {
                                     must: [
                                       { match: { "chat.number": chat_number } },
                                       { match: { "chat.application.token": app_token } },
                                       { match: { "content": query } }
                                     ]
                                   }
                               }
                           })
    response.results.map { |r| { number: r._source.number, content: r._source.content } }
  end

  # elasticsearch index
  def as_indexed_json(_options = nil)
    as_json(
      only: [:id, :number, :content],
      include: {
        chat: {
          only: [:id, :number],
          include: {
            application: { only: [:token] }
          }
        }
      }
    )
  end

  settings index: { number_of_shards: 1, analysis: {
    filter: {
      trigrams_filter: {
        type: "ngram",
        min_gram: 3,
        max_gram: 3
      }
    },
    analyzer: {
      trigrams: {
        type: "custom",
        tokenizer: "standard",
        filter: ["lowercase", "trigrams_filter"]
      }
    }
  } } do
    mappings dynamic: 'false' do
      indexes :id, type: :integer
      indexes :number, type: :integer
      indexes :content, type: :text, analyzer: :trigrams
      indexes :chat do
        indexes :id, type: :integer
        indexes :number, type: :integer
        indexes :application do
          indexes :token, type: :text
        end
      end
    end
  end

end
