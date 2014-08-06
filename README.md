# Trackman 

## Rails Environment Variables

I'm using the Figaro gem to set up few environment variables

``` config/application.yml
smtp_username: "<enter gmail address here>"
smtp_password: "<enter gmail password here>"
db_password: "<enter password for Traccar mysql database here>"
```

`IMPORTANT`: The file above doesn't exist by default inside the config folder, so you'll have to create it` !

#### About the required variables

The `smtp_username` and `smtp_password` are used by __ActionMailer__ to send confirmation emails.

The `db_password` is used to connect to the MySQL database used by Traccar! (see `config/database.yml`)

## Creating the admin user 

Run : 

    RAILS_ENV=production rake:seed_fu

## Traccar server configuration file 

```
    <!-- Global configuration -->
    <entry key='database.driver'>com.mysql.jdbc.Driver</entry>
    <entry key='database.dataSource'>com.mysql.jdbc.jdbc2.optional.MysqlDataSource</entry>
    <entry key='database.url'>jdbc:mysql://127.0.0.1:3306/traccar?allowMultiQueries=true&amp;autoReconnect=true</entry>
    <entry key='database.user'>root</entry>
    <entry key='database.password'> `ENTER YOUR PASSWORD HERE` </entry>

    <!-- Database refresh delay in seconds -->
    <entry key='database.refreshDelay'>5</entry>

    ... 
    ...
    ...
```

Check Wiki for details about why it's important to change the refresh delay. 



 



