# Installation

##1. Traccar server configuration file 

[Configuration file example](https://github.com/haj/trackman/wiki/Configuration-file-snippet)

Also it's important to change Traccar default refresh delay as shown in the configuration file example above, [here's why.](https://github.com/haj/trackman/wiki/About-Traccar-server-refresh-rate)


## 2. Rails Environment Variables

Certain credentials and parameters required to run the app are stored in a special file named `application.yml` and loaded using the figaro gem. 

Here's an example of such file : [config/application.yml](https://github.com/haj/trackman/wiki/application.yml)

## 3. Seed admin account
Running the seed_fu (powered by the seed_fu gem), it'll take care of the rest :
 
```
RAILS_ENV=production rake:seed_fu
```
The __seed data__ is located inside the `db/fixtures` directory.

## 4. DROP all foreign keys on traccar database tables 

   It is important to deactivate all foreign keys on tables, because their database is setup in such a way that you can't remove a device without removing a position and you can't remove a last position without removing device.  


## 5. Set up MySQL timezone

The app expects MySQL Timezone to be UTC.




 



