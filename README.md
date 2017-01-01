# PocketUrl

This is a small link shortening application, built with Rails 5, Ruby 2.4.0, Postgresql.

## Features

The following features are implemented:

- receive a URL and return the shortened URL
- redirects the shortened URL to the original URL
- a stats API endpoint at `/api/v1/short_url` that gives details about visitors

See [feature specs](spec/features) and [requests specs](spec/requests) for more details.

## Demo
See a [demo deploy here](https://pocketurl.herokuapp.com).

## Todo
#### Provide more stats on visitors
Currently the following is recorded:
  + uid: non-expiring cookie keeps a uuid to identify visitor's device(not the visitor himself)
  + ip address
  + user agent
  + referrer
  + timestamp of visit

#### Improve stats performance

Stats are queried on the fly when requested. This will not be scalable. Once the requirements of stats is stable, we can use the postgres's materialised view to cache the query, or have background jobs that updates a stats table either by batch or per visit(but this has some scaling issues with table locking of each visits tries to update a row).

#### Other scaling issues

As traffic grows, we'll hit different bottlenecks:
  + Currently visits are stored as a relational table with integer id. We can change the type of :id from int to bigint

  + Visit table size. This table being a record of each visit can grow quite fast. When it exceeds the postgres server's memory size, we can consider [partitioning the table into smaller physical tables](https://www.postgresql.org/docs/9.5/static/ddl-partitioning.html). Or use a cluster friendly, fast-write database like Cassandra.

  + If we expect many concurrent visitors, we can scale the web server vertically and then horizontally.

  + We can do away with keeping a visits table altogether, and provide statistics of visits by parsing request logs. The visits table is essentially just a request log, expecting no update operation. Splitting the responsibility of providing statistics and shortening urls into separate application also increases modularity and thus maintainability.
