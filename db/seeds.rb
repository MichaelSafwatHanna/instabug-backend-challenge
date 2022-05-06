(0..10).each do |i|
  Application.create({
                       name: "Application #{i}"
                     })
end
