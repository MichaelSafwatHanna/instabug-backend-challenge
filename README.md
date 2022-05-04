# Instabug backend challenge

- [Instabug backend challenge](#instabug-backend-challenge)
  - [Problem definition](#problem-definition)
  - [Phases](#phases)
    - [Analysis](#analysis)
      - [Database design](#database-design)
        - [Application](#application)
        - [Chats](#chats)
        - [Messages](#messages)
      - [API Design](#api-design)
        - [Models](#models)
        - [Endpoints](#endpoints)
    - [Implementation](#implementation)
  - [Tradeoffs](#tradeoffs)
  - [To improve](#to-improve)

## Problem definition

It’s required to build a chat system. The system should allow creating new applications where
each application will have a token (generated) and a name (provided).

The token is the identifier that devices use to send chats to that application.

Each application can have many chats, and each chat should have a number.
Numbering of chats in each application starts from 1 (no 2 chats in the same application may have the same number). The number of the chat should be returned in the chat creation request.

A chat contains messages where messages have numbers that start from 1 for each chat (no 2 messages in the chat application may have the same number). The number of the message should also be returned in the message creation request.

The client should never see the ID of any of the entities, The client identifies the application by its token and the chat by its number along with the application token.

It's required to have an endpoint for searching through messages of a specific chat, It should be able to partially match messages’ bodies (Elasticsearch should be used for this).

The applications table should contain a column called chats_count that contains the number of chats for this application. Similarly, the chats table should contain a column called messages_count that contains the number of messages in this chat. These columns don’t have to be live. However, they shouldn’t be lagging more than 1 hour.

Assume that the system is to receive many requests. It might be running on multiple servers in parallel and thus multiple requests may be processed concurrently. Make sure to handle race conditions.

Try to minimize the queries and avoid writing directly to MySQL while serving the requests (especially for the chats and messages creation endpoints). You can use a queuing system to achieve that.

It is allowed for chats and messages to take time to be persisted.

You should optimize your tables by adding appropriate indices.
Your app should be containerized. We should only run `docker-compose up` to run the whole stack.

## Phases

### Analysis

#### Database design

##### Application

| column      | details           |
| :---------- | :---------------- |
| id          | PK, int, not null |
| token       | uuid, not null    |
| name        | string, not null  |
| chats_count | int, default: 0   |

##### Chats

| column         | details                                                 |
| :------------- | :------------------------------------------------------ |
| id             | PK, int, not null                                       |
| application_id | FK (Application.Id), int, not null                      |
| number         | int, int, not null (starts from 1 for each application) |
| messages_count | int, default: 0                                         |

##### Messages

| column  | details                                          |
| :------ | :----------------------------------------------- |
| id      | PK, int, not null                                |
| chat_id | FK (Chats.Id), int, not null                     |
| number  | int, int, not null (starts from 1 for each chat) |
| content | string, not null                                 |

#### API Design

##### Models

```()
Message: {
    number: int;
    content: string;
}
```

```()
Chat: {
    messages_count: int;
    messages: Message[ ];
}
```

##### Endpoints

POST /applications

Request

```()
{
    name: string;
}
```

Response

```()
{
    token: uuid;
}
```

GET /applications/[application_token]

Response

```()
{
    name: string;
    chats_count: int;
}
```

POST /application/[application_token]/chat

Response

```()
{
    chat_number: int;
}
```

GET /application/[application_token]/chat/[chat_number]

Response

```()
{
    messages_count: int;
    messages: Message[];
}
```

POST /application/[application_token]/chat/[chat_number]/message

Request

```()
{
    content: string;
}
```

Response

```()
{
    message_number: int;
}
```

GET /application/[application_token]/chat/[chat_number]/messages/[message_number]

Response

```()
{
    content: string;
}
```

GET /application/[application_token]/chat/[chat_number]/search?q=[search_terms]

Response

```()
{
    messages: Message[];
}
```

### Implementation

- [x] Implement basic crud operations for all entities (without numbering and queueing) [2 days]
- [x] Implement entity numbering [1 day]
- [x] Implement queueing [1 day]
- [x] Implement search endpoint along with elastic search connection [1 day]
- [ ] Unit testing
- [ ] Refactoring

## Tradeoffs

- Adding the app token to all entities' rows VS Adding the app id

| PROS           | CONS                                                               |
| :------------- | :----------------------------------------------------------------- |
| Simple queries | Data duplication (but won’t be an issue as the token is immutable) |

---

- Use DB table for tracking sequential numbering VS using Redis

| PROS                                                                                      | CONS                                                  |
| :---------------------------------------------------------------------------------------- | :---------------------------------------------------- |
| DB easier in integration and access                                                       | DB is slower and will increase traffic on it.         |
| Redis is in memory so 10x faster and will distribute the load instead of consuming the db | Redis requires additional setup and first time to use |

---

## To improve

- [ ] Improve dev environment scripts, maybe use npm.
