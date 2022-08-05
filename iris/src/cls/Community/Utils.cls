Class Community.Utils [ Abstract ]
{

ClassMethod setup(globalPath As %String = "", facts = 10000) As %Status
{
	if globalPath = "" {
		write "Please input path to global GZ file.", !
		return $$$ERROR(5001, "Please input path to global XML file.")
	}
	
	try {
		if globalPath[".gz"  do ..importXMLGlobal(globalPath)
		if globalPath[".xml" do $System.OBJ.Load(globalPath)
	} catch e {
		set sc = e.AsStatus()
		w "Err ",e.Name, ": ", e.Data, ": ", e.Location, !
		return sc
	}
	
	write "Enabling iKnow",!
	set sc=..enableIknow()
	return:$$$ISERR(sc) sc

	write "Building indices", !
	set sc = ..buildIndices()
	return:$$$ISERR(sc) sc
	
	write "Building cubes", !
	set sc = ..UpdateCubes(,facts)
	return:$$$ISERR(sc) sc
	
	w "Done!", !
	return $$$OK
}

ClassMethod enableIknow() As %Status
{
	set app = $System.CSP.GetDefaultApp($znspace)
	new $NAMESPACE
	set $NAMESPACE = "%SYS"
	set props("DeepSeeEnabled") = 1
	set props("iKnowEnabled") = 1
	do ##class(Security.Applications).Modify(app, .props)
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

ClassMethod UpdateCubes(verbose = 1, facts = 10000) As %Status
{
	set st = ##class(%DeepSee.Utils).%GetCubeList(.list, "cubes")
	return:$$$ISERR(st) st
 
	set cube=""
	for {
		set cube=$Order(list(cube)) 
		#; if (cube="POST") continue
		#;if (ViewsLoad = "False") 
		#;{
		#;	if (cube="ViewsHistory") continue
		#;	if (cube="ViewsHistoryCopy") continue
		#;}
		quit:cube=""

		Set st1 = ##class(%DeepSee.Utils).%BuildCube(cube, $$$YES, verbose,,facts)
		
		set st = $$$ADDSC(st, st1) 
	}
	return st
}

}
