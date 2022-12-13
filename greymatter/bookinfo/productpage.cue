package bookinfo

import (
	gsl "greymatter.io/gsl/v1"

	"bookinfo.module/greymatter:globals"
)

Productpage: gsl.#Service & {
	context: Productpage.#NewContext & globals

	name:              "productpage"
	display_name:      "Bookinfo Productpage"
	version:           "v1.0.0"
	description:       "Book info product web app"
	api_endpoint:      "http://\(context.globals.edge_host)/"
	api_spec_endpoint: "http://\(context.globals.edge_host)/"
	business_impact:   "low"
	owner:             "Library"
	capability:        "Web"

	ingress: {
		(name): {
			gsl.#HTTPListener
			routes: "/": upstreams: "local": instances: [{host: "127.0.0.1", port: 9090}]
		}
	}
	
	egress: {
		"egress-to-services": {
			gsl.#HTTPListener
			port: 9080
			routes: {
				"/details/": {
					prefix_rewrite: "/details/"
					upstreams: {
						"details": {
							namespace: "bookinfo"
						}
					}
				}
				"/ratings/": {
					prefix_rewrite: "/ratings/"
					upstreams: {
						"ratings": {
							namespace: "bookinfo"
						}
					}
				}
				"/reviews/": {
					prefix_rewrite: "/reviews/"
					upstreams: {
						"reviews-v2": {
							namespace: "bookinfo"
						}
					}
				}
			}
		}
	}
	edge: {
		edge_name: "edge"
		routes: "/": upstreams: (name): {namespace: context.globals.namespace}

	}
}

exports: "productpage": Productpage
