package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.net.*;
import java.util.*;
import org.jboss.jmx.adaptor.model.*;
import java.io.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.InstanceManager _jsp_instancemanager;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
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

      out.write("<?xml version=\"1.0\"?>\n");
      out.write("\n");
      out.write("<!DOCTYPE html \n");
      out.write("    PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n");
      out.write("    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n");

      String bindAddress = "";
      String serverName = "";
      try
      {
         bindAddress = System.getProperty("jboss.bind.address", "");
         serverName = System.getProperty("jboss.server.name", "");
      }
      catch (SecurityException se) {}

      String hostname = "";
      try
      {
         hostname = InetAddress.getLocalHost().getHostName();
      }
      catch(IOException e)  {}

      String hostInfo = hostname;
      if (!bindAddress.equals(""))
      {
         hostInfo = hostInfo + " (" + bindAddress + ")";
      }
   
      out.write("\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>JBoss JMX Management Console - ");
      out.print( hostInfo );
      out.write("</title>\n");
      out.write("</head>\n");
      out.write("<!-- frames -->\n");
      out.write("<frameset  cols=\"255,*\">\n");
      out.write("    <frame name=\"ObjectFilterView\" src=\"filterView.jsp\"                   marginwidth=\"10\" marginheight=\"10\" scrolling=\"auto\" frameborder=\"0\">\n");
      out.write("    <frame name=\"ObjectNodeView\"   src=\"HtmlAdaptor?action=displayMBeans\" marginwidth=\"10\"  marginheight=\"10\" scrolling=\"auto\" frameborder=\"0\">\n");
      out.write("    <noframes>A frames enabled browser is required for the main view</noframes>\n");
      out.write("</frameset>\n");
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
