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

## DROP all foreign keys on traccar tables

    ALTER TABLE devices DROP FOREIGN KEY `FK5CF8ACDD7C6208C3`;


## Add a new column to the positions table in the traccar db : 

```
ALTER TABLE `positions` ADD `created_at` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
```

## Set up MySQL timezone
Usually it's best to setup MySQL Timezone to UTC.
Or 
Set the System Timezone to UTC. 



 



