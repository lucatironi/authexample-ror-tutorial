authexample-ror-tutorial
============================

AuthExample Ruby on Rails Application created for the tutorial posted on [lucatironi.github.io](http://lucatironi.github.io).

[Ruby on Rails and Android Authentication Part One](http://lucatironi.github.io/tutorial/2012/10/15/ruby_rails_android_app_authentication_devise_tutorial_part_one)

In this three-part tutorial you'll learn how to build an authentication API that can allow external users to register, login and logout through JSON requests, with Ruby On Rails.

[Ruby on Rails and Android Authentication Part Two](http://lucatironi.github.io/tutorial/2012/10/16/ruby_rails_android_app_authentication_devise_tutorial_part_two)

The second part of the tutorial will let you code an Android app that uses the JSON authentication API developed in the previous tutorial.

[Ruby on Rails and Android Authentication Part Three](http://lucatironi.github.io/tutorial/2012/12/07/ruby_rails_android_app_authentication_devise_tutorial_part_three)

I wanted to add some more features to the Android app and its Rails backend. Now the user can create and complete tasks just like in a real ToDo mobile application.

## Installation

```
git clone https://github.com/lucatironi/authexample-ror-tutorial.git
cd authexample-ror-tutorial
bundle install
rake db:create db:migrate
rails s
```