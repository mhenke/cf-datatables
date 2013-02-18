cf-datatables
=============

using datatables with coldfusion custom tag

## Examples of Calling Custom Tag

    71: <cf_datatables  disablesort="9" tableid="contributionnotreceivedreport">  
    <cfset querystring = { sel_code=sel_code,SELACT=SELACT,SELADM=SELADM,SELTAN=SELTAN,SELIO=SELIO,selpol=selpol,seltan=seltan }>                      
    <cf_datatables tableid="act_dashboarddetail2" toolbar="true" serverside="true" querystring=#querystring#>

    138: <cf_datatables tableid="dashboarddetail" toolbar="true">  

    254: <cf_datatables tableid="dashboardstatusdetail" sorttype="null,null,null,date,null,formatted-num">  

    141: <cf_datatables tableid="btrackdetail" sorttype="null,formatted-num,formatted-num,formatted-num,formatted-num,formatted-num,null,null,null,null,null" sort="[0, 'asc']" toolbar="true"> 

    <cf_datatables tableid="acctpol_action" sorttype="null,null,null,null,date" sort="[0, 'asc']" toolbar="false" serverside="true" showentries="false">

## Css include examples

    <link rel="stylesheet" href="/solutiontrack/Library/css/dt_table.css" type="text/css" media="screen">
    <link rel="stylesheet" href="/solutiontrack/Library/css/TableTools.css" type="text/css" media="screen">
    <link rel="stylesheet" href="/solutiontrack/Library/css/ColVis.css" type="text/css" media="screen">
    <link rel="stylesheet" href="/solutiontrack/Library/css/print.css" type="text/css" media="print">

## Js include examples

    <script type="text/javascript" language="javascript"  src="/solutiontrack/library/js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" language="javascript"  src="/solutiontrack/library/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript"  src="/solutiontrack/library/js/ZeroClipboard.js"></script>
    <script type="text/javascript" language="javascript"  src="/solutiontrack/library/js/TableTools.js"></script>
    <script type="text/javascript" language="javascript" src="/solutiontrack/library/js/ColReorder.min.js" ></script>
    <script type="text/javascript" language="javascript" src="/solutiontrack/library/js/ColVis.min.js" ></script>
    <script type="text/javascript" language="javascript" src="/solutiontrack/library/js/Scroller.min.js" ></script