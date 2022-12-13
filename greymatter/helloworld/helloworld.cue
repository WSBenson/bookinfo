package bookinfo

import (
	gsl "greymatter.io/gsl/v1"

	"bookinfo.module/greymatter:globals"
	policies "bookinfo.module/greymatter/policies"
)


Helloworld: gsl.#Service & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Helloworld.#NewContext & globals

	name:          "helloworld"
	display_name:  "Helloworld"
	version:       "v1.0.0"
	description:   "testing service"
	api_endpoint:              "https://abbef2a0421344c97ab6b0f050a69f92-1552748289.us-east-1.elb.amazonaws.com:10808/services/bookinfo/\(name)/"
	api_spec_endpoint:         "https://abbef2a0421344c97ab6b0f050a69f92-1552748289.us-east-1.elb.amazonaws.com:10808/services/bookinfo/\(name)/"
	business_impact:           "low"
	owner: ""
	capability: ""
	health_options: {
		tls: gsl.#MTLSUpstream
	}
	// Helloworld -> ingress to your container
	ingress: {
		(name): {
			gsl.#HTTPListener
			gsl.#MTLSListener
			
			//  NOTE: this must be filled out by a user. Impersonation allows other services to act on the behalf of identities
			//  inside the system. Please uncomment if you wish to enable impersonation. If the servers list if left empty,
			//  all traffic will be blocked.
				filters: [
			//    gsl.#ImpersonationFilter & {
			//		#options: {
			//			servers: ""
			//			caseSensitive: false
			//		}
			//    }
					gsl.#RBACFilter & {
					  #option: {
						policies.#RBAC.#DenyAll
					  }
					},
				]

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


	
	// Edge config for the Helloworld service.
	// These configs are REQUIRED for your service to be accessible
	// outside your cluster/mesh.
	edge: {
		edge_name: "edge"
		routes: "/services/bookinfo/helloworld": upstreams: (name): {
			gsl.#MTLSUpstream
			namespace: "bookinfo"
		}
	}
	
}

exports: "helloworld": Helloworld
