<%@page import="java.io.*,java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.ArrayList" language="java" %>
<%@page import="java.util.Arrays" language="java" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="org.apache.poi.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook,org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Cell,org.apache.poi.hssf.record.cf.FontFormatting"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell,org.apache.poi.hssf.usermodel.HSSFCellStyle,org.apache.poi.hssf.usermodel.HSSFDataFormat,org.apache.poi.hssf.usermodel.HSSFRow,org.apache.poi.hssf.usermodel.HSSFSheet,org.apache.poi.hssf.usermodel.HSSFWorkbook,org.apache.poi.hssf.util.HSSFColor" language="java" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell,org.apache.poi.hssf.usermodel.HSSFCellStyle" language="java" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFont" language="java" %>
<%@page errorPage="sqlerror.jsp" %>

<%
            String check = request.getParameter("User");
            if (check == null) {
                //response.sendRedirect("https://dpdcentral.inservices.tatamotors.com/dpd/MSD_Portal/cgi/index.cgi?Utilities_Usage");
                //response.sendRedirect("http://172.22.97.30/dpd/QA/cgi/index.cgi?Utilities_Usage");
            }
%>

<html>
    <head><title>Log Generate </title>
        
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demos.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/PageStyles.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/demo.css">
        
        <% String from = request.getParameter("from");%>
        <% String to = request.getParameter("to");%>

        <%
                    ArrayList ApplicationListNewVersions = new ArrayList();
                    ArrayList ApplicationListOldVersions = new ArrayList();
                    ArrayList ApplicationList = new ArrayList();
                    Class.forName("oracle.jdbc.OracleDriver");
                    String url = "jdbc:oracle:thin:@172.22.97.7:1521:PCLRDB";
                    Connection dbconnection = DriverManager.getConnection(url, "elecdept", "tiger");
                    Statement statement = dbconnection.createStatement();
                    ResultSet resultSet = statement.executeQuery("select Distinct APPLICATIONNAME from KBEAPPUSAGE WHERE APPLICATIONNAME NOT IN ('TML Mastico')");
                    while (resultSet.next()) {
                           if((resultSet.getString(1).toString().contains("Version 3.0") == false) && (resultSet.getString(1).toString().contains("Version 2.2") == false) && (resultSet.getString(1).toString().contains("TML Mastico v1.0")== false)) {
                               ApplicationList.add(resultSet.getString(1));
                           }
                         //ApplicationList.add(resultSet.getString(1));
                    }
                    
                    Collections.sort(ApplicationList, String.CASE_INSENSITIVE_ORDER);
                    //resultSet.close();
                    //statement.close();
                    //dbconnection.close();
        %>

        <script type="text/javascript">
            function CheckForm()
        {
            var appSelect = document.getElementById("Application");
            var app = appSelect.options[appSelect.selectedIndex].value;
            if(app == " "){
                alert ("Please Select an Option");
            } else 
            {
                
            }
        }
            return false;
        }
        
        </script>
        

        <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="js/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="js/jquery.ui.datepicker.js"></script>
        
        
         <script>
               
            $(function () {
                $("#from").datepicker({
                    defaultDate: "+lw",
                    dateFormat: 'dd-mm-yy', 
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    onClose: function (selectedDate) {
                        $("#to").datepicker("option", "minDate", selectedDate);
                    }
                });
                $("#to").datepicker({
                    defaultDate: "+lw",
                    dateFormat: 'dd-mm-yy',
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    onClose: function (selectedDate) {
                        $("#from").datepicker("option", "maxDate", selectedDate);
                    }
                });
            });


        </script>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo_table.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo_page.css">
        
        <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/js/jquery.dataTables.js"></script>
        
        <script type="text/javascript">

            $(document).ready(function(){
                //To sort the table in ascending order of the elements in column 2
                $('#example').dataTable( {
                    "aaSorting": [[ 0, "asc" ]]
                } );
            });
        </script>
        
        
    </head>
    <body>
        <!-- Get the data in the database and push it into arraylist -->
        <form id ="appForm1" action="LogGenerate_New.jsp" onsubmit="return Form_Submit()" method ="post">
            <div class="styled-select" style="font-family:Georgia,serif;color:#000;font-size: 16px;">
                Select Application&nbsp;:&nbsp;&nbsp;&nbsp;
                <select name="Application" id="Application" class="Application">
                    <option value=" ">Select   ---------</option>
                    <option value="All">All</option>
                    <%                        for (int i = 0;
                                        i < ApplicationList.size();
                                        i++) {%>
                    <option value="<%=ApplicationList.get(i)%>"><%=ApplicationList.get(i)%></option>
                    <%                                            }%>
                </select>
                <label for="from">From</label>
                <input type="text" id="from" name="from">
                <label for="to">To</label>
                <input type="text" id="to" name="to">
                <br>
                <br>
                    <input type="submit" value="Generate" class="button"/>
                    <input type ="reset" value="Reset"  class="button" />
            </div>
        </form>
        
        <%
                    ArrayList UserName = new ArrayList();
                    ArrayList MachineName = new ArrayList();
                    ArrayList RunDate = new ArrayList();
                    ArrayList RunTime = new ArrayList();
                    ArrayList PartNumber = new ArrayList();
                    ArrayList ProjectCode = new ArrayList();
                    ArrayList DesignGroup = new ArrayList();
                    ArrayList QPPVersion = new ArrayList();
                    ArrayList SuccessfulPass = new ArrayList();
                    ArrayList Warning = new ArrayList();
                    ArrayList AutoCorrection = new ArrayList();
                    ArrayList Manual = new ArrayList();
                    ArrayList SemiAuto = new ArrayList();
                    ArrayList ComponentType = new ArrayList();
                    boolean flag = false;
                    
                    

                    String ReqApplication = request.getParameter("Application");
                    if (ReqApplication != null) 
                    {
                        if (ReqApplication.equalsIgnoreCase("")) 
                        {
                            
                        }
                        else {
                  
                                Class.forName("oracle.jdbc.OracleDriver");
                                //String url = "jdbc:oracle:thin:@172.22.97.7:1521:PCLRDB";
                                //Connection dbconnection = DriverManager.getConnection(url, "elecdept", "tiger");
                                //Statement statement = dbconnection.createStatement();
                                //ResultSet resultSet;
                                if ((from != null) && (to != null)) {
                                if (ReqApplication.equalsIgnoreCase("All")) {
                                    resultSet = statement.executeQuery("select * from KBEAPPUSAGE");
                                } else {
                                    resultSet = statement.executeQuery("select * from KBEAPPUSAGE where APPLICATIONNAME='" + ReqApplication + "'");
                                }
                                } else {
                                    flag = true;
                                    resultSet = statement.executeQuery("select * from KBEAPPUSAGE");
                                }
                                
                                while (resultSet.next()) {
                                            
                                            String InterDate[] = resultSet.getString("RUNDATE").split("-");
                                            String date = InterDate[2] + InterDate[1] + InterDate[0];
                                            if(flag == true){
                                            UserName.add(resultSet.getString("USERNAME"));
                                            MachineName.add(resultSet.getString("MACHINENAME"));
                                            RunDate.add(resultSet.getString("RUNDATE"));
                                            RunTime.add(resultSet.getString("TIME"));
                                            PartNumber.add(resultSet.getString("PARTNUMBER"));
                                            ProjectCode.add(resultSet.getString("PROJECTCODE"));
                                            DesignGroup.add(resultSet.getString("DESIGNGROUP"));
                                            QPPVersion.add(resultSet.getString("APPLICATIONNAME"));
                                            SuccessfulPass.add(resultSet.getString("SUCCESSFULPASS"));
                                            Warning.add(resultSet.getString("WARNING"));
                                            AutoCorrection.add(resultSet.getString("AUTOCORRECTION"));
                                            Manual.add(resultSet.getString("MANUAL"));
                                            SemiAuto.add(resultSet.getString("SEMIAUTO"));
                                            ComponentType.add(resultSet.getString("COMPONENTTYPE"));
                                            }
                                            else {
                                            String fromdate = request.getParameter("from");
                                            String todate = request.getParameter("to");

                                            String fromInt[] = fromdate.split("-");
                                            String toInter[] = todate.split("-");

                                            from = fromInt[2]+fromInt[1]+fromInt[0];
                                            to = toInter[2]+toInter[1]+toInter[0];
                                            if ((Integer.parseInt(date) >= Integer.parseInt(from)) && (Integer.parseInt(date) <= Integer.parseInt(to))) {
                                            UserName.add(resultSet.getString("USERNAME"));
                                            MachineName.add(resultSet.getString("MACHINENAME"));
                                            RunDate.add(resultSet.getString("RUNDATE"));
                                            RunTime.add(resultSet.getString("TIME"));
                                            PartNumber.add(resultSet.getString("PARTNUMBER"));
                                            ProjectCode.add(resultSet.getString("PROJECTCODE"));
                                            DesignGroup.add(resultSet.getString("DESIGNGROUP"));
                                            QPPVersion.add(resultSet.getString("APPLICATIONNAME"));
                                            SuccessfulPass.add(resultSet.getString("SUCCESSFULPASS"));
                                            Warning.add(resultSet.getString("WARNING"));
                                            AutoCorrection.add(resultSet.getString("AUTOCORRECTION"));
                                            Manual.add(resultSet.getString("MANUAL"));
                                            SemiAuto.add(resultSet.getString("SEMIAUTO"));
                                            ComponentType.add(resultSet.getString("COMPONENTTYPE"));
                                            }
                                           }
                                        }

                                resultSet.close();
                                statement.close();
                                dbconnection.close();
                                %>
                                
                                <div id="demo">
                                    <table style=" overflow: auto; width: 100%" cellpadding="0" cellspacing="0" border="0" class="display" id="example">
                                        <thead>
                                            <tr style=" color: white; font-weight: bolder;  font-size: 15px;font-family:Georgia, serif; background: #3388CC;">
                                                <td align="center">Sr. No</td>
                                                <td align="center">Username</td>
                                                <td align="center">Machinename</td>
                                                <td align="center">Rundate</td>
                                                <td align="center">Time</td>
                                                <td align="center">Partnumber</td>
                                                <td align="center">Projectcode</td>
                                                <td align="center">Designgroup</td>
                                                <td align="center">APPLICATIONNAME</td>
                                                <td align="center">SuccessfulPass</td>
                                                <td align="center">Warning</td>
                                                <td align="center">AutoCorrection</td>
                                                <td align="center">Manual</td>
                                                <td align="center">SemiAuto</td>
                                                <td align="center">ComponentType</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                        for (int i = 0; i < UserName.size(); i++) {
                                            %>
                                            <tr style=" color: #333; font-size: 13px;font-family:Georgia, serif;" >
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(i + 1);%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(UserName.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(MachineName.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(RunDate.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(RunTime.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(PartNumber.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(ProjectCode.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(DesignGroup.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(QPPVersion.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(SuccessfulPass.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(Warning.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(AutoCorrection.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(Manual.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(SemiAuto.get(i).toString());%></td>
                                                <td align="center" style=" padding-top: 6px; padding-bottom: 6px;"><%out.print(ComponentType.get(i).toString());%></td>
                                            </tr>
                                            <%
                                                        }
                                            %>
                                        </tbody>
                                    </table>
                                </div>

                   <%    }
                    }

        %>
        
        
        
        
    </body>
</html>

<script type="text/javascript">
    function Form_Submit(){
        
        var appSelect = document.getElementById("Application");
        var app = appSelect.options[appSelect.selectedIndex].value;
        
        var start_date = document.getElementById('from').value;
        var end_date = document.getElementById('to').value;
        
        if(app == " ") {
            alert('Please select an Application!');
            return false;
        }
        else if(start_date == ''){
            alert('Please select an start date!');
            return false;
        }else if(end_date == ''){
            alert('Please select End Date!');
            return false;
        }else {
           // document.getElementById("appForm2").submit();
        }
    }
</script>


