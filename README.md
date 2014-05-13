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

1.Sign up through the web interface (and create a dummy company when asked)
 
4.Then add the admin role to the user you just create (here we're searching for the user by email so make sure you put the correct email in the where clause)

```ruby
admin = User.where(email: "<type the email address here>") 
admin.roles << :admin
admin.save!
```

## Traccar server configuration file 

When configuring Traccar server it's important to change the `database.refreshDelay` from the default `300 seconds` to something smaller (like `5 seconds`), because here's a scenario when the initial value create problems : 

If for some reason a device start pinging the server before it's EMEI/UniqueId was added to the database, obviously the server will flag it as `unknown device` and the GPS data received by the server will be ignored and not saved in the database! 

Now if we add the device EMEI/UniqueId to the traccar database and we stop/start the Android client for example we would expect the server to stop flagging that device as `unknown device` and start storing GPS data for that device in the database, but sadly it's not the case, at least not after the `300 seconds` specified by the `database.refreshDelay`! So that's why it's important to change the `300 seconds` constant! 


```
    <!-- Global confiduration -->
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
