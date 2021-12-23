open util/integer

/*********************** PRIMITIVE TYPES ************************/

sig Username, Password, id, personalinformation{}

/************************* SIGNATURES ***************************/

abstract sig User {
	ID: id,
	username: Username,
	password: Password,
	PersonalInformation: personalinformation
}

sig PolicyMaker extends User {
	publish: some Policy
}
sig Farmer extends User {
	create: some DiscussionForum,
	join: some DiscussionForum,
	suggest: some Suggestion, 
}
sig Agronomist extends User {
	responsibilityArea: one Area, 
	suggest: some Suggestion, 
	schedule: one DailyPlan
}

sig Area {
	farms: some Farm
}

sig Farm {
	farmers: one Farmer
}

sig  DiscussionForum{
} {
}

sig Policy {
}

sig DailyPlan {
	receiver:  one Agronomist
}

sig Suggestion {
	give: some Farmer
}

/************************** FACTS *******************************/

// Usernames of registered users are unique.
fact uniqueUsernames {
	no disjoint u1, u2: User |
		u1.username = u2.username
}


// A farm is always belonging to a area
fact farmAlwaysInArea {
all f: Farm | one a: Area | f in a.farms
}
//A farmer is always belonging to a farm
fact farmerAlwaysInFarm {
all f: Farmer | one a: Farm | f in a.farmers
}
// A daily plan is always belonging to a agronomist
fact dailyPlanAlwaysInAgronomist {
all d: DailyPlan | one a: Agronomist | d in a.schedule
}

// A area is always associated with only one agronomist
fact areaAlwaysAssociated
{
all a: Area | one g: Agronomist | a in g.responsibilityArea
}

// A suggestion is always associated with only one agronomist
fact suggestionAlwaysAssociated
{
all s: Suggestion | one a: Agronomist | s in a.suggest
}

// A policy is always belonging to a policy maker
fact policyAlwaysInpolicyMaker {
all p: Policy | one m: PolicyMaker | p in m.publish
}


/************************ PREDICATES ****************************/

pred show { 
	#PolicyMaker = 2
	#Farmer >= 10
	#Agronomist = 5
	#Suggestion = 10
	#Farm >= 10 
	#Policy = 1
	#Area = 6
}
/************************** WORLDS ******************************/
run show for 50
