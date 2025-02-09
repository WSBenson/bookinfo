package globals

import (
	gsl "greymatter.io/gsl/v1"
)

globals: gsl.#DefaultContext & {
	edge_host: "aa78bbd52f6b7407fab8b3305c68f505-1386730301.us-east-1.elb.amazonaws.com:10809"
	namespace: "bookinfo"

	// Please contact your mesh administrators as to what
	// values must be set per your mesh deployment.
	mesh: {
		name: "greymatter-mesh"
	}
	// Custom allows for any type of custom constants.
	// For more complex custom CUE, you should explore storing it in files
	// under the policies folder.
	custom: {
		default_egress: 9080
	}
}
