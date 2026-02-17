extends Resource
class_name MEFExecutionGroup


enum Group {
	## Effects that must run before anything else
	EARLY = 0,

	## Main payload
	MAIN = 100,

	## Secondary effects
	LATE = 200,

	## Cleanup / reset effects
	CLEANUP = 300
}
