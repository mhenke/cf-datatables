<!---
Script: DataTables server-side script for ColdFusion (cfm) and MySQL
License: GPL v2 or BSD (3-point)
Notes:
tested with DataTables 1.6.1 and jQuery 1.2.6+, Adobe ColdFusion 9 (but should work fine on at least 7+)
to work with pre 1.6 datatables replace both occurances of sSortDir_ with iSortDir_
Get a free developer version of ColdFusion from http://www.adobe.com/products/coldfusion/
or try out the open source railo cfml engine from http://www.getrailo.org/
or try out the open source openbd cfml engine from http://www.openbluedragon.org/
--->

<!--- turn off debugging output --->
<cfsetting showDebugOutput="No">
<cfset listColumns = "" />
<cfset listColumnsCast = "" />
<cfset flag_cast = 0 />

<cfset arrayMetaData = getMetaData(evaluate("session.#filename#")) />
<cfset qOriginal = replace(de('session.#filename#'),'"','','all') />

<cfloop index="thisColumn" from="1" to="#arraylen(arrayMetaData)#">
	<cfset listColumns = ListAppend(listColumns, arrayMetaData[thisColumn]["Name"]) />
	<cfset listColumnsCast = ListAppend(listColumnsCast, "CAST(#arrayMetaData[thisColumn]["Name"]# as VARCHAR) as #arrayMetaData[thisColumn]["Name"]#") />
	
	<cfif arrayMetaData[thisColumn]["TypeName"] NEQ "VARCHAR">
		<cfset flag_cast = 1 />
	</cfif>
</cfloop>

<!--- set query of queries --->
<cfset objAttributes.dbtype = "query"/>

<cfif flag_cast>
	<!--- set columns to varchar --->
	<cfset objAttributes.name="queryObject" />
	<cfquery attributecollection="#objAttributes#">
	SELECT #listColumnsCast#
	FROM #qOriginal#
	</cfquery>
</cfif>

<!--- query name for filtering data set--->
<cfset objAttributes.name="qFiltered" />

<!---
Paging
--->
<cfparam name="url.iDisplayStart" default="0" type="integer" />
<cfparam name="url.iDisplayLength" default="10" type="integer" />
<cfparam name="url.sIndexColumn" default="1" />

<cfparam name="url.sSearch" default="" type="string" />

!---
Ordering
--->
<cfparam name="url.iSortingCols" default="0" type="integer" />

<!--- Data set after filtering --->
<cfquery attributecollection="#objAttributes#">
	SELECT #listColumns#
	FROM #qOriginal#
	
	<!--- setup where clause --->
	<cfif len(trim(url.sSearch))>
		WHERE
		1 = 0
		<!--- filter --->
		<cfloop index="thisColumn" from="1" to="#arraylen(arrayMetaData)#">
			OR CAST(UPPER(#arrayMetaData[thisColumn]["Name"]#) AS VARCHAR)
			LIKE <cfqueryparam value="%#ucase(trim(url.sSearch))#%">
		</cfloop>
	</cfif>
	
	<!--- Ordering --->
	ORDER BY
	<cfif url.iSortingCols gt 0>
		<cfloop from="0" to="#url.iSortingCols-1#" index="thisS">
		<cfif thisS is not 0>, </cfif>
			#listGetAt(listColumns,(url["iSortCol_"&thisS]+1))#
			<cfif listFindNoCase("asc,desc",url["sSortDir_"&thisS]) gt 0>#url["sSortDir_"&thisS]#</cfif>
		</cfloop>
	<cfelse>
		#sIndexColumn#
	</cfif>
</cfquery>

<!--- set length for the initial unfiltered data set --->
<cfset qCount.total = evaluate("session.#filename#.recordcount")>

<!--- Output --->
<cfcontent reset="Yes" />
{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>,
"iTotalRecords": <cfoutput>#qCount.total#</cfoutput>,
"iTotalDisplayRecords": <cfoutput>#qFiltered.recordCount#</cfoutput>,
"aaData": [
<cfoutput query="qFiltered" startrow="#val(url.iDisplayStart+1)#" maxrows="#((val(url.iDisplayLength) LT 0) ?  val(evaluate('#qOriginal#.recordcount')) : val(url.iDisplayLength))#">

<cfif currentRow gt (url.iDisplayStart+1)>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn">
<cfif thisColumn neq listFirst(listColumns)>,</cfif>
#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#
</cfloop>
]
</cfoutput>
] }