//
// Vivado(TM)
// rundef.js: a Vivado-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
  PathVal = "E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/ids_lite/ISE/bin/nt64;E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/ids_lite/ISE/lib/nt64;E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/bin;";
} else {
  PathVal = "E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/ids_lite/ISE/bin/nt64;E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/ids_lite/ISE/lib/nt64;E:/Faculta/AN2_SEM2/AC_LAB/Vivado/2016.4/bin;" + PathVal;
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


ISEStep( "vivado",
         "-log test_env.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source test_env.tcl" );



function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
