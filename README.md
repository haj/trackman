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