Pants::Application.configure do
  # Typically, users will be able to create new sites on your IndiePants
  # instance as soon as they can reach it through a host name that so far
  # hasn't been taken. You may want to restrict these to a specific pattern;
  # IndiePants will match the host name against the following regular
  # expression to see if it's claimable by a user.
  #
  config.x.claimable_hosts = /.*/
end
