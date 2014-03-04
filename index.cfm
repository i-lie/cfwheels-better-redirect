<style type="text/css">
<!--
.highlight {
	color: #F60;
}
-->
</style>
<h1>Better Redirects</h1>

<p>
	This plugin is a fork of <a href="http://cfwheels.org/plugins/listing/17">BetterRedirects plugin</a> by Clarke Bishop.<br>
	The difference is that it will add the <b>returnUrl</b> parameter in the url instead of using session.
</p>

<p>This plugin adds some redirect helpers. It's based on blog post by Connor McKay: <a href="http://ethilien.net/archives/better-redirects-in-rails/">Better Redirects in Rails</a>. <br />
(Studying Rails solutions can be a great way to resolve programming problems in Wheels.)</p>

<h2>Description</h2>

<p>The methods provided by this plugin extends and enhances the redirect helpers provided by Wheels.</p>
<p>Here's an example requirement. For user authentication, it is typical to do a redirect to a login page when the user tries to access a protected page. But, where do they go after  login? It is nice to remember their original  URL and send them back. RedirectAway() and RedirectBack() make this easy.</p>

<h2>Methods Added</h2>

<p>Here is a listing of the methods that are added by this plugin.</p>

<ul>
	<li>FlashRedirectToIndex (flashMessage) - Inserts a <span class="highlight">notice</span> message into the the Flash and redirects to the index action..</li>
	<li>FlashRedirect (flashMessage, [value]) -  Inserts a <span class="highlight">notice</span> message into the the Flash and calls <span class="highlight">RedirectTo()</span>. You can pass any <a href="http://cfwheels.org/docs/function/redirectto">RedirectTo values</a> to the method.</li>
	<li>RedirectAway (variableName, [value]) - Saves the currentURL to the session, and calls <span class="highlight">RedirectTo()</span>. You can pass any <a href="http://cfwheels.org/docs/function/redirectto">RedirectTo values</a> to the method.</li>
	<li>RedirectBack (variableName, [value]) - If the currentURL is defined in the session, redirects there. If it isn't defined, calls <span class="highlight">RedirectTo()</span>.</li>
</ul>


<h2>Uninstallation</h2>
<p>To uninstall this plugin simply delete the <tt>/plugins/BetterRedirects-xxx.zip</tt> file.</p>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://www.resultantsys.com">Clarke Bishop</a>.</p>

<p><a href="<cfoutput>#cgi.http_referer#</cfoutput>">&lt;&lt;&lt; Go Back</a></p>