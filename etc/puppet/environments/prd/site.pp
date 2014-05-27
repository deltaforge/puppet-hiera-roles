# Puppet site.pp for hiera-based roles
$hiera_roles=hiera("roles",[])

# Save into a field-separated string for further parsing
# (deltaforge_roles is now also available as a 'fact' to hiera!)
$deltaforge_roles=join($hiera_roles,"###")

# Look up roles and include as context
each($hiera_roles) |$role| {
    notify {"Parsing role: ${role}": }
    hiera_include($role)
}
