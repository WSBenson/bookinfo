package bookinfo

import (
	gsl "greymatter.io/gsl/v1"

	"bookinfo.module/greymatter:globals"
)

Details2: gsl.#Service & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Details2.#NewContext & globals

	name:              "details2"
	display_name:      "Bookinfo Details2"
	version:           "v1.0.0"
	description:       "EDIT ME"
	api_endpoint:      "http://\(context.globals.edge_host)/\(context.globals.namespace)/\(name)/"
	api_spec_endpoint: "http://\(context.globals.edge_host)/\(context.globals.namespace)/\(name)/"
	business_impact:   "low"
	owner:             "Library"
	capability:        ""

	// Details2 -> ingress to your container
	ingress: {
		(name): {
			gsl.#HTTPListener

			routes: {
				"/": {
					upstreams: {
						"local": {

							instances: [
								{
									host: "127.0.0.1"
									port: 443
								},
							]
						}
					}
				}
			}
		}
	}

	// Edge config for the Details2 service.
	// These configs are REQUIRED for your service to be accessible
	// outside your cluster/mesh.
	edge: {
		edge_name: "edge"
		routes: "/services/\(context.globals.namespace)/\(name)": upstreams: (name): {
			namespace: context.globals.namespace
		}
	}

}

exports: "details2": Details2
