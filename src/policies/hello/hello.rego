package policies.hello

import rego.v1

# default to a "closed" system,
# only grant access when explicitly granted

default allowed := false

allowed if {
	input.role == "web-admin"
}

default enabled := false

enabled if {
	visible
}

default visible := false

visible if {
	input.app == "web-console"
}
