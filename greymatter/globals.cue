package globals

import (
	gsl "greymatter.io/gsl/v1"
)

globals: gsl.#DefaultContext & {
	edge_host: "a288c147bb55847a695d474842f8c155-1064442323.us-east-1.elb.amazonaws.com:10809"
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
