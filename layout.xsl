<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="date">
    <xsl:output indent="yes" method="html" />

    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="createLink">
        <xsl:param name="value"/>

        <xsl:variable name="stage1">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$value"/>
                <xsl:with-param name="replace" select="'\'"/>
                <xsl:with-param name="by" select="'.'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$stage1" />
            <xsl:with-param name="replace" select="'/'" />
            <xsl:with-param name="by" select="'.'" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="/project/namespace" mode="menu">
        <xsl:variable name="link">
            <xsl:call-template name="createLink">
                <xsl:with-param name="value" select="@full_name"/>
            </xsl:call-template>
        </xsl:variable>

        <li>
            <a href="{$root}namespaces/{$link}.html">
                <i class="icon-th"></i>&#160;<xsl:value-of select="@full_name" />
            </a>
        </li>
    </xsl:template>

    <xsl:template match="/project/package" mode="menu">
        <xsl:variable name="name" select="@name"/>

        <xsl:variable name="link">
            <xsl:call-template name="createLink">
                <xsl:with-param name="value" select="@full_name"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- only show those packages that actually have visible contents -->
        <xsl:if test="/project/package[@name=$name]/package|/project/file/constant[@package=$name]|/project/file/function[@package=$name]|/project/file/class[@package=$name]|/project/file/interface[@package=$name]">
            <li>
                <a href="{$root}packages/{$link}.html">
                    <i class="icon-folder-open"></i>&#160;<xsl:value-of select="@full_name" />
                </a>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="/" mode="header">
      <div class="topnav">
        <div class="navbar navbar-fixed-top">
          <div class="navbar-inner">
            <div class="container">
              <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </a>
              <div class="brand">
                <strong>Proem</strong> Framework
              </div>
              <div class="nav-collapse">
                <ul class="nav">
                  <li><a href="/">Home</a></li>
                  <li><a href="https://proemframework.atlassian.net">Issues</a></li>
                  <li><a href="/docs">Documentation</a></li>
                  <li><a href="/api/namespaces/Proem.html">API</a></li>
                  <li><a href="/contrib.html">Contribute</a></li>
                  <li><a href="/about.html">About</a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:template>

    <xsl:template match="/" mode="footer"></xsl:template>

    <xsl:template match="/" mode="content-footer">
        <footer class="span12">
        </footer>
    </xsl:template>

    <xsl:template match="/" mode="title"></xsl:template>

    <xsl:template match="/" mode="head">
        <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
        <meta charset="utf-8" />
        <title>
            <xsl:value-of select="$title" disable-output-escaping="yes" />
            <xsl:if test="$title = ''">phpDocumentor</xsl:if>
            <xsl:apply-templates select="." mode="title"/>
        </title>
        <meta name="author" content="Mike van Riel" />
        <meta name="description" content="" />

        <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
        <![endif]-->

        <link href="{$root}css/template.css" rel="stylesheet" media="all" />
        <script src="{$root}js/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="{$root}js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
        <script src="{$root}js/jquery.mousewheel.min.js" type="text/javascript"></script>
        <script src="{$root}js/bootstrap.js" type="text/javascript"></script>
        <script src="{$root}js/template.js" type="text/javascript"></script>
        <script src="{$root}js/prettify/prettify.min.js" type="text/javascript"></script>

        <link rel="shortcut icon" href="{$root}img/favicon.ico" />
        <link rel="apple-touch-icon" href="{$root}img/apple-touch-icon.png" />
        <link rel="apple-touch-icon" sizes="72x72" href="{$root}img/apple-touch-icon-72x72.png" />
        <link rel="apple-touch-icon" sizes="114x114" href="{$root}img/apple-touch-icon-114x114.png" />
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-21713077-3']);
            _gaq.push(['_trackPageview']);
            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
    </xsl:template>

    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <html lang="en">
            <head><xsl:apply-templates select="." mode="head"/></head>
            <body>
                <xsl:apply-templates select="." mode="header"/>
                <div id="___" class="container">
                    <noscript>
                        <div class="alert alert-warning">
                            Javascript is disabled; several features are only available
                            if Javascript is enabled.
                        </div>
                    </noscript>

                    <xsl:apply-templates select="/project" mode="contents" />
                    <div class="row">
                        <xsl:apply-templates select="." mode="content-footer" />
                    </div>
                </div>
                <xsl:apply-templates select="." mode="footer" />
            </body>
        </html>
    </xsl:template>

    <xsl:template match="/" mode="report-overview">
        <li>
            <a href="{$root}errors.html">
                <i class="icon-remove-sign"></i>&#160;Errors&#160;
                <span class="label label-info"><xsl:value-of select="count(/project/file/parse_markers/*)" /></span>
            </a>
        </li>
        <li>
            <a href="{$root}markers.html">
                <i class="icon-map-marker"></i>&#160;Markers&#160;
                <ul>
                    <xsl:apply-templates select="/project/marker" mode="report-overview" />
                </ul>
            </a>
        </li>
        <li>
            <a href="{$root}deprecated.html">
                <i class="icon-stop"></i>&#160;Deprecated elements&#160;
                <span class="label label-info"><xsl:value-of select="/project/deprecated/@count" /></span>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="/project/marker" mode="report-overview">
        <xsl:variable name="marker" select="."/>
        <xsl:if test="./@count > 0">
            <li>
                <xsl:value-of select="$marker" />&#160;
                <span class="label label-info"><xsl:value-of select="./@count" /></span>
            </li>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
