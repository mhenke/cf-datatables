<cfcontent reset="true" type="application/json" />

<!--- sets filename as session variable --->
<cfset filename = evaluate("replace(GetFileFromPath(GetCurrentTemplatePath()),'.cfm','')")>
<cfparam name="session.#evaluate("filename")#" default=""> 

<!--- if sessions not set on server or initial request, the variable will not be a query --->
<cfif not IsQuery(evaluate("session.#filename#"))>
	<!--- initial data set for query of queries --->
	<CFQUERY name="qrydatatable">
	<!--- sql here if need links you will need to build them out like
		'<a href="/mike/rocks/cool.cfm?id=urlencodedformat('+convert(varchar(10),x.id)+')">'+x.name+'</a>' as link

		--->
</cfquery>
	<!--- SQL queries Get data to display --->
	<cfset "session.#filename#" = qrydatatable>
</cfif>

<!--- initial sorting column --->
<cfset sIndexColumn = "next_due_date" />

<!--- generic processing (no need to touch)--->
<cfinclude template="/solutiontrack/library/datatables_processing.cfm" />