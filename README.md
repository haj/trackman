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

1.Sign up through the web interface 

3.Go to Rails console and set up the current tenant

```ruby
Tenant.set_current_tenant(Tenant.first.id)

#if we don't set up the current tenant we won't be able to see members, the same goes for other tenanted models
```
 
4.Then add the admin role to the User/Member roles 

```ruby
# Make sure you use the Member model and not the User model
admin = Member.first 
admin.roles << :admin
admin.save!
```