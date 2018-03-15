<html>
<head>
    <title>[@ww.text name='bamboo.about.title' /]</title>
</head>

<body>
    <h2>[@ww.text name='bamboo.about.title' /]</h2>
    <p>Copyright © 2013 Atlassian Corporation Pty Ltd.</p>

    <p>The use of this product is subject to the terms of the <a href="http://www.atlassian.com/end-user-agreement">End User License Agreement</a>  unless otherwise specified therein.</p>
    <p>This product uses software developed by the <a href="http://www.apache.org">Apache Software Foundation</a>.</p>
    <p>
        This product also includes the following libraries which are covered by the GNU LGPL:
        [#--This function is in an auto-generated soy file derived from third-party-licensing/bom.csv--]
        ${soy.render('bamboo.web.resources:bamboo-about-page', 'bamboo.page.about.lgplLibraries', {})}
    </p>
    <p>This product also includes code written by other third parties.</p>
    <p>Additional details regarding these and other third party code included in this product, including applicable copyright, legal and licensing notices, are available in the "licenses" directory under the Bamboo installation directory.</p>
</body>
</html>