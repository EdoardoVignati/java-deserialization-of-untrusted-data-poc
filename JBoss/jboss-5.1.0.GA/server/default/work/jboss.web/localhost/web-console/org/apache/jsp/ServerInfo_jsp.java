package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class ServerInfo_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {


public String memSize (java.lang.Long lOctets)
{
	long octets = lOctets.longValue();
	int ratio = 3*1024;
	String unit = "";
	if (octets > ratio)
	{
	   unit = "KB";
	   octets/=1024;	
	   
		if (octets > ratio)
		{
		   unit = "MB";
		   octets/=1024;	
		   
			if (octets > ratio)
			{
			   unit = "GB";
			   octets/=1024;	
			   
				if (octets > ratio)
				{
				   unit = "TB";
				   octets/=1024;	
				}
			}
		}
	}
	
	return octets + " " + unit;
}

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(1);
    _jspx_dependants.add("/WEB-INF/tlds/webconsole.tld");
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.InstanceManager _jsp_instancemanager;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.release();
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');
      out.write('\n');
      //  jb:mbean
      org.jboss.console.plugins.helpers.servlet.MBeanTag _jspx_th_jb_005fmbean_005f0 = (org.jboss.console.plugins.helpers.servlet.MBeanTag) _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.get(org.jboss.console.plugins.helpers.servlet.MBeanTag.class);
      _jspx_th_jb_005fmbean_005f0.setPageContext(_jspx_page_context);
      _jspx_th_jb_005fmbean_005f0.setParent(null);
      // /ServerInfo.jsp(9,0) name = id type = java.lang.String reqTime = false required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f0.setId("server");
      // /ServerInfo.jsp(9,0) name = mbean type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f0.setMbean("jboss.system:type=Server");
      // /ServerInfo.jsp(9,0) name = intf type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f0.setIntf("org.jboss.system.server.ServerImplMBean");
      int _jspx_eval_jb_005fmbean_005f0 = _jspx_th_jb_005fmbean_005f0.doStartTag();
      if (_jspx_th_jb_005fmbean_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f0);
        return;
      }
      _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f0);
      org.jboss.system.server.ServerImplMBean server = null;
      server = (org.jboss.system.server.ServerImplMBean) _jspx_page_context.findAttribute("server");
      out.write('\n');
      //  jb:mbean
      org.jboss.console.plugins.helpers.servlet.MBeanTag _jspx_th_jb_005fmbean_005f1 = (org.jboss.console.plugins.helpers.servlet.MBeanTag) _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.get(org.jboss.console.plugins.helpers.servlet.MBeanTag.class);
      _jspx_th_jb_005fmbean_005f1.setPageContext(_jspx_page_context);
      _jspx_th_jb_005fmbean_005f1.setParent(null);
      // /ServerInfo.jsp(10,0) name = id type = java.lang.String reqTime = false required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f1.setId("serverInfo");
      // /ServerInfo.jsp(10,0) name = mbean type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f1.setMbean("jboss.system:type=ServerInfo");
      // /ServerInfo.jsp(10,0) name = intf type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f1.setIntf("org.jboss.system.server.ServerInfoMBean");
      int _jspx_eval_jb_005fmbean_005f1 = _jspx_th_jb_005fmbean_005f1.doStartTag();
      if (_jspx_th_jb_005fmbean_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f1);
        return;
      }
      _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f1);
      org.jboss.system.server.ServerInfoMBean serverInfo = null;
      serverInfo = (org.jboss.system.server.ServerInfoMBean) _jspx_page_context.findAttribute("serverInfo");
      out.write('\n');
      //  jb:mbean
      org.jboss.console.plugins.helpers.servlet.MBeanTag _jspx_th_jb_005fmbean_005f2 = (org.jboss.console.plugins.helpers.servlet.MBeanTag) _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.get(org.jboss.console.plugins.helpers.servlet.MBeanTag.class);
      _jspx_th_jb_005fmbean_005f2.setPageContext(_jspx_page_context);
      _jspx_th_jb_005fmbean_005f2.setParent(null);
      // /ServerInfo.jsp(11,0) name = id type = java.lang.String reqTime = false required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f2.setId("serverConfig");
      // /ServerInfo.jsp(11,0) name = mbean type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f2.setMbean("jboss.system:type=ServerConfig");
      // /ServerInfo.jsp(11,0) name = intf type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_jb_005fmbean_005f2.setIntf("org.jboss.system.server.ServerConfigImplMBean");
      int _jspx_eval_jb_005fmbean_005f2 = _jspx_th_jb_005fmbean_005f2.doStartTag();
      if (_jspx_th_jb_005fmbean_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f2);
        return;
      }
      _005fjspx_005ftagPool_005fjb_005fmbean_0026_005fmbean_005fintf_005fid_005fnobody.reuse(_jspx_th_jb_005fmbean_005f2);
      org.jboss.system.server.ServerConfigImplMBean serverConfig = null;
      serverConfig = (org.jboss.system.server.ServerConfigImplMBean) _jspx_page_context.findAttribute("serverConfig");
      out.write('\n');

   String myUrl = response.encodeURL(request.getRequestURI());

      out.write('\n');
      out.write("\n");
      out.write("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\">\n");
      out.write("<head>\n");
      out.write("<title>JBoss Management Console - Server Information</title>\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n");
      out.write("<link rel=\"StyleSheet\" href=\"css/jboss.css\" type=\"text/css\"/>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("<!-- header begin -->\n");
      out.write("\t<img src=\"images/logo.gif\" alt=\"JBoss\" id=\"logo\" width=\"226\" height=\"105\" />\n");
      out.write("\t<div id=\"header\">\n");
      out.write("\t\t&nbsp;</div>\n");
      out.write("\t<div id=\"navigation_bar\">\n");
      out.write("\t</div>\n");
      out.write("<!-- header end -->\n");
      out.write("<hr class=\"hide\"/>\n");
      out.write("\t<center>\n");
      out.write("\t<div id=\"content\">\n");
      out.write("\t\t<div class=\"content_block\" style=\"width: 100%; height: 247\">\n");
      out.write("\t\t\t<h3>JBoss&trade; Application Server</h3>\n");
      out.write("\t\t\t\t\t<p>&nbsp;</p>\n");
      out.write("\t\t\t\t<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"95%\" align=\"center\" id=\"AutoNumber1\">\n");
      out.write("                  <tr>\n");
      out.write("                    <td width=\"50%\" align=\"center\" colspan=\"2\">\n");
      out.write("                    <h4 style=\"text-align: center\"><font size=\"3\">JBoss</font></h4>\n");
      out.write("                    </td>\n");
      out.write("                  </tr>\n");
      out.write("                  <tr>\n");
      out.write("                    <td width=\"25%\" align=\"center\" valign=\"top\">\n");
      out.write("                    <h4>Version</h4>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Version: </b>");
      out.print(server.getVersion());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Version Name: </b>");
      out.print(server.getVersionName());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Built on: </b>");
      out.print(server.getBuildDate());
      out.write("</font>\n");
      out.write("                    </td>\n");
      out.write("                    <td width=\"25%\" align=\"center\" valign=\"top\">\n");
      out.write("                    <h4>Environment</h4>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Start date: </b>");
      out.print(server.getStartDate());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Host: </b>");
      out.print(serverInfo.getHostName());
      out.write(' ');
      out.write('(');
      out.print(serverInfo.getHostAddress ());
      out.write(")</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Base Location: </b>");
      out.print(serverConfig.getServerBaseURL());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Base Location (local): </b>");
      out.print(serverConfig.getServerBaseDir());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Running config: </b>'");
      out.print( serverConfig.getServerHomeDir().getName());
      out.write("'</font></td>\n");
      out.write("                  </tr>\n");
      out.write("\t\n");
      out.write("            </table>\n");
      out.write("            <p>&nbsp;</p>\n");
      out.write("\t\t\t\t<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"95%\" align=\"center\" id=\"AutoNumber1\">\n");
      out.write("                  <tr>\n");
      out.write("                    <td width=\"50%\" align=\"center\" colspan=\"2\">\n");
      out.write("                    <h4 style=\"text-align: center\"><font size=\"3\">JVM - Hardware</font></h4>\n");
      out.write("                    </td>\n");
      out.write("                  </tr>\n");
      out.write("                  <tr>\n");
      out.write("                    <td width=\"25%\" align=\"center\" valign=\"top\">\n");
      out.write("                    <h4>Hardware</h4>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>#CPU: </b>");
      out.print(serverInfo.getAvailableProcessors());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>OS: </b>");
      out.print(serverInfo.getOSName());
      out.write(' ');
      out.print(serverInfo.getOSVersion());
      out.write(' ');
      out.write('(');
      out.print(serverInfo.getOSArch());
      out.write(")</font></td>\n");
      out.write("                    <td width=\"25%\" align=\"center\" valign=\"top\">\n");
      out.write("                    <h4>JVM Environment</h4>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Free Memory: </b>");
      out.print(memSize(serverInfo.getFreeMemory()));
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Max Memory: </b>");
      out.print(memSize(serverInfo.getMaxMemory()));
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>Total Memory: </b>");
      out.print(memSize(serverInfo.getTotalMemory()));
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>#Threads: </b>");
      out.print(serverInfo.getActiveThreadCount());
      out.write("</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>JVM Version: </b>");
      out.print(serverInfo.getJavaVMVersion());
      out.write(' ');
      out.write('(');
      out.print(serverInfo.getJavaVMVendor());
      out.write(")</font></p>\n");
      out.write("                    <p align=\"left\"><font size=\"1\"><b>JVM Name: </b>");
      out.print(serverInfo.getJavaVMName());
      out.write("</font></td>\n");
      out.write("                  </tr>\n");
      out.write("\n");
      out.write("            </table>\n");
      out.write("\t\t\t\t\t<p>&nbsp;</p>\n");
      out.write("            <p align=\"center\"> <a href=\"");
      out.print(myUrl);
      out.write("\">Refresh</a></p>\n");
      out.write("\n");
      out.write("\t\t\t\t\t<p>&nbsp;</p>\n");
      out.write("\t\t\t\t\t<p>&nbsp;</p>\n");
      out.write("\t\t\t\t\t<p>&nbsp;</p>\n");
      out.write("\t\t</div>\n");
      out.write("\t\t<div class=\"spacer\"><hr/></div>\n");
      out.write("\t</div>\n");
      out.write("\t</center>\n");
      out.write("<!-- content end -->\n");
      out.write("\n");
      out.write("<hr class=\"hide\"/>\n");
      out.write("<!-- footer begin -->\n");
      out.write("\t<div id=\"footer\">\n");
      out.write("\t\t<div id=\"credits\">JBoss&trade; Management Console</div>\n");
      out.write("\t\t<div id=\"footer_bar\">&nbsp;</div>\n");
      out.write("\t</div>\n");
      out.write("<!-- footer end -->\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
