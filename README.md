# Getting Started

## Setup Traccar 

### Traccar server configuration file 

```
    <!-- This is the database stuff -->
    <entry key='database.driver'>com.mysql.jdbc.Driver</entry>
    <entry key='database.dataSource'>com.mysql.jdbc.jdbc2.optional.MysqlDataSource</entry>
    <entry key='database.url'>jdbc:mysql://127.0.0.1:3306/traccar?allowMultiQueries=true&amp;autoReconnect=true</entry>
    <entry key='database.user'>root</entry>
    <entry key='database.password'> `ENTER YOUR PASSWORD HERE` </entry>

    <!-- Don't forget to change the refreshDelay !!!!!!!!!!!! -->
    <entry key='database.refreshDelay'>5</entry>

    ... 
    ...
    ...
```

Check Wiki for details about why it's important to change the refresh delay. 


## Rails Environment Variables

Create a new file `config/application.yml`


Populate it following this template by filling in the required password details : 


``` config/application.yml
smtp_username: "<enter gmail address here>"
smtp_password: "<enter gmail password here>"
db_password: "<enter password for TRACCAR mysql database here>"
```

## Setup the admin stuff
Run the seed_fu stuff, it'll take care of the rest :
 
```
RAILS_ENV=production rake:seed_fu
```





 



