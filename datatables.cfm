<!--- sort types: num-html, formatted-num, anti-the, string, numeric, date, null, or html  --->
<cfparam name="attributes.tableid" type="string" />
<cfparam name="attributes.serverside" type="boolean" default="false" />
<cfparam name="attributes.sorttype" type="string" default="false"/>
<cfparam name="attributes.sort" type="string" default="false"/>
<cfparam name="attributes.toolbar" type="boolean" default="true"/>
<cfparam name="attributes.scroller" type="boolean" default="false"/>
<cfparam name="attributes.colvis" type="boolean" default="false"/>
<cfparam name="attributes.reorder" type="boolean" default="false"/>
<cfparam name="attributes.state" type="boolean" default="false"/>
<cfparam name="attributes.showentries" type="boolean" default="true"/>
<cfparam name="attributes.querystring" type="struct" default="#StructNew()#"/>
<cfparam name="attributes.disablesort" type="string" default=""/>
<cfparam name="attributes.datefilter" type="array" default="#ArrayNew(1)#"/>
<cfparam name="attributes.iDisplayLength" type="string" default="10"/>
<cfparam name="attributes.individualColumnFilter" type="boolean" default="false"/>

<!--- must have position 1 and 2 and both integers --->
<!--- default if don't exist 3 (current date mins 30) and 4 (current date plus 30) AND they are both dates--->
<!--- http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=functions-pt0_03.html --->
<cfif ArrayLen(attributes.datefilter)>
	<div id="baseDateControl">
	 	<div align="center">
	        Between <input type="text" name="dateStart" id="dateStart" class="jquerydatepicker" value="<cfoutput>#dateformat(attributes.datefilter[3],"mm/dd/yyyy")#</cfoutput>" size="8" /> and 
	        <input type="text" name="dateEnd" id="dateEnd" class="jquerydatepicker" value="<cfoutput>#dateformat(attributes.datefilter[4],"mm/dd/yyyy")#</cfoutput>" size="8"/>
	    </div>
	</div>
</cfif>

<cfset attributes.sortarray = ListToArray(attributes.sorttype)>
<cfset attributes.sortarraylen = ArrayLen(attributes.sortarray)>

<!--- on initial request, run query --->
<cfset "session.#attributes.tableid#" = "" />
	<script type="text/javascript" charset="utf-8">
		
	<cfif attributes.individualColumnFilter>
		(function($) {
			/*
			 * Function: fnGetColumnData
			 * Purpose:  Return an array of table values from a particular column.
			 * Returns:  array string: 1d data array 
			 * Inputs:   object:oSettings - dataTable settings object. This is always the last argument past to the function
			 *           int:iColumn - the id of the column to extract the data from
			 *           bool:bUnique - optional - if set to false duplicated values are not filtered out
			 *           bool:bFiltered - optional - if set to false all the table data is used (not only the filtered)
			 *           bool:bIgnoreEmpty - optional - if set to false empty values are not filtered from the result array
			 * Author:   Benedikt Forchhammer <b.forchhammer /AT\ mind2.de>
			 */
			$.fn.dataTableExt.oApi.fnGetColumnData = function ( oSettings, iColumn, bUnique, bFiltered, bIgnoreEmpty ) {
				// check that we have a column id
				if ( typeof iColumn == "undefined" ) return new Array();
				
				// by default we only wany unique data
				if ( typeof bUnique == "undefined" ) bUnique = true;
				
				// by default we do want to only look at filtered data
				if ( typeof bFiltered == "undefined" ) bFiltered = true;
				
				// by default we do not wany to include empty values
				if ( typeof bIgnoreEmpty == "undefined" ) bIgnoreEmpty = true;
				
				// list of rows which we're going to loop through
				var aiRows;
				
				// use only filtered rows
				if (bFiltered == true) aiRows = oSettings.aiDisplay; 
				// use all rows
				else aiRows = oSettings.aiDisplayMaster; // all row numbers
			
				// set up data array	
				var asResultData = new Array();
				
				for (var i=0,c=aiRows.length; i<c; i++) {
					iRow = aiRows[i];
					var aData = this.fnGetData(iRow);
					var sValue = aData[iColumn];
					
					// ignore empty values?
					if (bIgnoreEmpty == true && sValue.length == 0) continue;
			
					// ignore unique values?
					else if (bUnique == true && jQuery.inArray(sValue, asResultData) > -1) continue;
					
					// else push the value onto the result data array
					else asResultData.push(sValue);
				}
				
				return asResultData;
			}}(jQuery));
			
		function fnCreateSelect( aData )
			{
				var r='<select><option value=""></option>', i, iLen=aData.length;
				for ( i=0 ; i<iLen ; i++ )
				{
					r += '<option value="'+aData[i]+'">'+aData[i]+'</option>';
				}
				return r+'</select>';
			}
	</cfif>	
	
	jQuery.fn.dataTableExt.oSort['num-html-asc']  = function(a,b) {
	    var x = a.replace( /<.*?>/g, "" );
	    var y = b.replace( /<.*?>/g, "" );
	    x = parseFloat( x );
	    y = parseFloat( y );
	    return ((x < y) ? -1 : ((x > y) ?  1 : 0));
	};
	 
	jQuery.fn.dataTableExt.oSort['num-html-desc'] = function(a,b) {
	    var x = a.replace( /<.*?>/g, "" );
	    var y = b.replace( /<.*?>/g, "" );
	    x = parseFloat( x );
	    y = parseFloat( y );
	    return ((x < y) ?  1 : ((x > y) ? -1 : 0));
	};	
		
	jQuery.fn.dataTableExt.oSort['formatted-num-asc'] = function(a,b) {
	    /* Remove any formatting */
	    var x = a.match(/\d/) ? a.replace( /[^\d\-\.]/g, "" ) : 0;
	    var y = b.match(/\d/) ? b.replace( /[^\d\-\.]/g, "" ) : 0;
	      
	    /* Parse and return */
	    return parseFloat(x) - parseFloat(y);
	};
	  
	jQuery.fn.dataTableExt.oSort['formatted-num-desc'] = function(a,b) {
	    var x = a.match(/\d/) ? a.replace( /[^\d\-\.]/g, "" ) : 0;
	    var y = b.match(/\d/) ? b.replace( /[^\d\-\.]/g, "" ) : 0;
	      
	    return parseFloat(y) - parseFloat(x);
	};	
	
	jQuery.fn.dataTableExt.oSort['anti-the-asc']  = function(a,b) {
	    var x = a.replace(/^the /i, "");
	    var y = b.replace(/^the /i, "");
	    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
	};
	 
	jQuery.fn.dataTableExt.oSort['anti-the-desc'] = function(a,b) {
	    var x = a.replace(/^the /i, "");
	    var y = b.replace(/^the /i, "");
	    return ((x < y) ? 1 : ((x > y) ? -1 : 0));
	};
	
	$(document).ready(function() {
	var $oTable = $('#<cfoutput>#attributes.tableid#</cfoutput>').dataTable(
	 {
	 	<cfif attributes.serverside>
	 	"bProcessing": true,
		"bServerSide": true,
		"sAjaxSource": "<cfoutput>#attributes.tableid#.cfm?<cfloop collection = #attributes.querystring# item = "urlname">#urlname#=#StructFind(attributes.querystring, urlname)#&</cfloop></cfoutput>",
		</cfif>
		
		"sPaginationType": "full_numbers",
		"aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
		
		<cfif attributes.state>
		"bStateSave": true,
		</cfif>
		
		<cfif len(attributes.disablesort)>
		"aoColumnDefs": [
      { "bSortable": false, "aTargets": [ <cfoutput>#attributes.disablesort#</cfoutput> ] }
    ],
		</cfif>
		
		"iDisplayLength": <cfoutput>#attributes.iDisplayLength#</cfoutput>,
		"sDom": '<cfif attributes.toolbar>T</cfif><cfif attributes.colvis>C</cfif><cfif attributes.toolbar or attributes.colvis><"clear"></cfif><cfif attributes.reorder>R</cfif><cfif attributes.showentries or attributes.toolbar>l</cfif>frtip<cfif attributes.scroller>S</cfif>'
		
		<cfif attributes.scroller>
		, "sScrollY": "200px",
		"bDeferRender": true,
		"bPaginate": false
		</cfif>
		
		<cfif attributes.toolbar>
		, "oTableTools": {
			"sSwfPath": "/solutiontrack/library/swf/copy_cvs_xls_pdf.swf",
			"sExtends": "text",
			"bHeader": true,
			"aButtons": [
				 {
                     "sExtends": "xls",
                     "sFileName": "TableTools.csv"
                 }, 
				"pdf", 
				"print" 
			]
		}
		</cfif>
		
		<cfif attributes.sortarray[1] neq 'false'>
		, "aoColumns": [
			<cfloop index="sType" from="1" to="#arrayLen(attributes.sortarray)#">
			 	<cfif attributes.sortarray[sType] EQ "null">
				 	null
				 <cfelse>
			    	{ "sType": "<cfoutput>#attributes.sortarray[sType]#</cfoutput>" }
			    </cfif>
				<cfif arrayLen(attributes.sortarray) neq sType>,</cfif>
			</cfloop>
		    ]
		</cfif>
		
		<cfif attributes.sort neq 'false'>
		,"aaSorting": [<cfoutput>#attributes.sort#</cfoutput>]
		</cfif>
	} 
	);
	
	<cfif ArrayLen(attributes.datefilter)>
	// The plugin function for adding a new filtering routine
	$.fn.dataTableExt.afnFiltering.push(
			function(oSettings, aData, iDataIndex){
				var dateStart = parseDateValue($("#dateStart").val());
				var dateEnd = parseDateValue($("#dateEnd").val());
				// aData represents the table structure as an array of columns, so the script access the date value 
				// in the first column of the table via aData[0]
				var evalDate= parseDateValue(aData[<cfoutput>#attributes.datefilter[2]#</cfoutput>]);
				
				if (evalDate >= dateStart && evalDate <= dateEnd) {
					return true;
				}
				else {
					return false;
				}
				
			});
	
	// Function for converting a mm/dd/yyyy date value into a numeric string for comparison (example 08/12/2010 becomes 20100812
	function parseDateValue(rawDate) {
		var dateArray= rawDate.split("/");
		var parsedDate= dateArray[2] + dateArray[0] + dateArray[1];
		return parsedDate;
	}
	
	<!--- $dateControls= $("#baseDateControl").children("div").clone();
	$("#<cfoutput>#attributes.tableid#</cfoutput>_filter").prepend($dateControls); 
	  --->
	 
	// Create event listeners that will filter the table whenever the user types in either date range box or
	// changes the value of either box using the Datepicker pop-up calendar
	$("#dateStart").keyup ( function() { $oTable.fnDraw(); } );
	$("#dateStart").change( function() { $oTable.fnDraw(); } );
	$("#dateEnd").keyup ( function() { $oTable.fnDraw(); } );
	$("#dateEnd").change( function() { $oTable.fnDraw(); } );
	</cfif>
	
	<cfif attributes.individualColumnFilter>
		/* Add a select menu for each TH element in the table footer */
		$("tfoot th.individual").each( function ( i ) {
			this.innerHTML = fnCreateSelect( $oTable.fnGetColumnData(i) );
			$('select', this).change( function () {
				$oTable.fnFilter( $(this).val(), i );
			} );
		} );
	</cfif>
} );
	</script>