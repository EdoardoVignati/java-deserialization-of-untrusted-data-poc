package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.apache.catalina.util.ServerInfo;
import org.apache.catalina.valves.Constants;
import org.apache.catalina.util.StringManager;

public final class genericError_jsp extends org.apache.jasper.runtime.HttpJspBase
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
    Throwable exception = org.apache.jasper.runtime.JspRuntimeLibrary.getThrowable(request);
    if (exception != null) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
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

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <style>\n");
      out.write("            <!--H1 {font-family:Tahoma, Arial, sans-serif; color:white; \n");
      out.write("                    background-color:#525D76; font-size:22px;} \n");
      out.write("                H3 {font-family:Tahoma, Arial, sans-serif; color:white; \n");
      out.write("                    background-color:#525D76; font-size:14px;}  \n");
      out.write("                HR {color:#525D76;} \n");
      out.write("                .errorText {font-family:Tahoma, Arial, sans-serif; font-size:16px; } -->\n");
      out.write("        </style>\n");
      out.write("        <title>\n");
      out.write("        ");

            StringManager sm = StringManager.getManager(Constants.Package);
            out.println(ServerInfo.getServerInfo() + " - " 
                        + sm.getString("errorReportValve.errorReport")); 
        
      out.write("\n");
      out.write("        </title>\n");
      out.write("    </head>\n");
      out.write("    <body>\n");
      out.write("        <h1>\n");
      out.write("        ");
 
            out.println(sm.getString("errorReportValve.statusHeader",
                        "" + pageContext.getErrorData().getStatusCode(), "")); 
        
      out.write("\n");
      out.write("        </h1>\n");
      out.write("        <hr size=\\\"1\\\" noshade=\\\"noshade\\\">\n");
      out.write("        <span class=\"errorText\">An error has occurred.</span>\n");
      out.write("        <hr size=\\\"1\\\" noshade=\\\"noshade\\\">\n");
      out.write("        <h3>");
      out.print( ServerInfo.getServerInfo() );
      out.write("</h3>\n");
      out.write("    </body>\n");
      out.write("</html>\n");
      out.write("\n");
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
