Class Community.Utils [ Abstract ]
{

ClassMethod setup(globalPath As %String = "") As %Status
{
	if globalPath = "" {
		write "Please input path to global GZ file.", !
		return $$$ERROR(5001, "Please input path to global XML file.")
	}
	
	try {
		do ..importXMLGlobal(globalPath)
	} catch e {
		set sc = e.AsStatus()
		w "Err ",e.Name, ": ", e.Data, ": ", e.Location, !
		return sc
	}
	
	write "Building indices", !
	set sc = ..buildIndices()
	return:$$$ISERR(sc) sc
	
	write "Building cubes", !
	set sc = ..UpdateCubes()
	return:$$$ISERR(sc) sc
	
	w "Done!", !
	return $$$OK
}

ClassMethod importXMLGlobal(globalPath As %String) As %Status
{
	set s=##class(%Stream.FileBinaryGzip).%New() 
	do s.LinkToFile(globalPath) 
	do $System.OBJ.LoadStream(s) 
	kill s
}

ClassMethod buildIndices() As %Status
{
	set sql="select Name from %Dictionary.CompiledClass where system=0 and NOT(Name %Startswith '%') AND SUPER [ 'Persistent'"
	set rs=##class(%SQL.Statement).%ExecDirect(,sql)
	while rs.%Next() { 
		set sc= $classmethod(rs.%GetData(1),"%BuildIndices") 
		write "Built "_rs.%GetData(1)_" with return code = "_sc,! 
	}
	
	return sc
}

ClassMethod UpdateCubes(verbose = 1) As %Status
{
 set st = ##class(%DeepSee.Utils).%GetCubeList(.list, "cubes")
 return:$$$ISERR(st) st
 
 set cube=""
 for {
   set cube=$Order(list(cube)) 
   
   quit:cube=""
   Set st1 = ##class(%DeepSee.Utils).%BuildCube(cube, $$$YES, verbose)
   
   // TODO Fix that hack
   if ((cube="POST") && 
    ($SYSTEM.Status.GetErrorCodes(st1) = 5001/*GeneralError*/) && 
    ($SYSTEM.Status.GetErrorText(st1) [ "Insert into dimension table failed")) {
     /// Reported as prodlog 141297
     set st1 = $$$OK
   }
   if (cube="POST") continue
   
   set st = $$$ADDSC(st, st1) 
 }
 return st
}

}

