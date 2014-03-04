<!---
	Based on Better Redirects in Rails:
	http://ethilien.net/archives/better-redirects-in-rails/
--->
<cfcomponent output="false">

	 <cffunction name="init">
		<cfset this.version = "1.0,1.01,1.1.8">
		<cfreturn this>
	 </cffunction>

	 <cffunction name="redirectToIndex"
	 	hint="RedirectToIndex(flashMessage) Set flash and redirect to index."
	 	description="This method is useful when you the user has just edited an object, and you now want to display a message
	 		in the flash like 'User updated successfully', and then redirect them back to the index action.">

		<cfargument name="flashMessage" default="" required="false">

		<cfif StructKeyExists(arguments,"flashMessage")>
			<cfset flashInsert(notice=arguments.flashMessage)>
		</cfif>

		<cfset redirectTo(action="index")>
	 </cffunction>

	 <cffunction name="flashRedirect"
	 	hint="FlashRedirect(flashMessage) Set flash and redirect to index."
	 	description="This method is useful when you want to display a message in the flash and then send them to another controller.
	 		FlashRedirect accepts both a message to be put in the flash, along with the params for redirectTo, so that you can
	 		flash a message and then send the user anywhere you please.">

		<cfif StructKeyExists(arguments,"flashMessage")>
			<cfset flashInsert(notice=arguments.flashMessage)>
			<cfset StructDelete(arguments, "flashMessage")>
		</cfif>

		<cfset redirectTo(argumentCollection=arguments)>
	 </cffunction>

	 <cffunction name="redirectAway"
	 	hint="RedirectAway(params) Saves URL, then does redirect."
	 	description="Store the original url in the session, and then redirect to the other action">

		<cfscript>
			var return_url = $getCurrentURL();

			// add the returnUrl param
			if (return_url != "") {
				if (IsDefined("arguments.params") && (arguments.params != "")) {
					arguments.params = arguments.params & "&";
				} else {
					arguments.params = "";
				}

				arguments.params = arguments.params &
									"returnUrl=" & return_url;
			}

			redirectTo(argumentcollection: arguments);
		</cfscript>
	 </cffunction>

	 <cffunction name="redirectBack"
	 	hint="RedirectBack(params) returns to the saved URL."
	 	description="Returns the person to either the original url from a redirect_away or to a default url.">

		<cfset var backUrl = "">
		<cfset var redirect_args = "">
		<cfset var pattern_args = "">

		<cfif StructKeyExists(params, "returnUrl")>
			<cfset backUrl = URLDecode(params.returnUrl)>
		</cfif>

		<cfif Len(backURL) GT 0>
			<cftry>
				<!--- find the matches route --->
				<cfset route = application.wheels.dispatch.$findMatchingRoute(backUrl)>

				<cfset redirect_args = {
					route = route.name,
					delay = true
				}>

				<!--- must pass the variables as well --->
				<cfset pattern_args = $parseRoutePattern(pattern: route.pattern,
														backUrl: backUrl)>

				<cfset StructAppend(redirect_args, pattern_args, true)>

				<!--- for unit testing purposes, we need to add the "delay" param --->
				<cfreturn redirectTo(argumentcollection: redirect_args)>
			<cfcatch type="any">
				<!--- fallback to cflocation if we can't find any matching route --->
				<cflocation url="#backURL#" addtoken="false">
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset redirectTo(argumentCollection: arguments)>
		</cfif>
	 </cffunction>

	<cffunction name="$getCurrentURL" access="public" output="false">
		<cfset var current_url = "">

		<!--- retreive the current url --->
		<cfset current_url = application.wheels.dispatch.$getPathFromRequest(CGI.path_info, CGI.script_name)>

		<!--- make sure that it always starts with "/" --->
		<cfif (current_url neq "") AND (Left(current_url, 1) neq "/")>
			<cfset current_url = "/" & current_url>
		</cfif>

		<cfreturn current_url>
	</cffunction>

	<cffunction name="$parseRoutePattern" access="public" returntype="struct" output="false" hint="Parse the url using the route's pattern.">
		<cfargument name="pattern" type="string" required="true" hint="The route pattern.">
		<cfargument name="backUrl" type="string" required="true" hint="The return url.">

		<cfset var regex_pattern = "">
		<cfset var find_pos = "">
		<cfset var matches_count = 0>
		<cfset var key = "">
		<cfset var value = "">
		<cfset var struct_out = {}>

		<cfset regex_pattern = "^" & REReplace(arguments.pattern, "\[.*?\]", "(.*)", "all") & "$">
		<cfset find_pos = REFindNoCase(regex_pattern, arguments.backUrl, 1, true)>
		<cfset matches_count = ArrayLen(find_pos.pos) - 1>

		<cfif matches_count gt 0>
			<cfloop index="i" from="1" to="#matches_count#">
				<cfset key = ListGetAt(route.variables, i, ",")>
				<cfset value = Mid(arguments.backUrl, find_pos.pos[i + 1], find_pos.len[i + 1])>

				<cfset struct_out[key] = value>
			</cfloop>
		</cfif>

		<cfreturn struct_out>
	</cffunction>
</cfcomponent>