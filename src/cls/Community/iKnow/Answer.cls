Include %IKPublic

Class Community.iKnow.Answer [ DependsOn = Community.Comment ]
{

Parameter DomainName As STRING = "CommunityAnswer";

Parameter BlackLists As STRING = "BLcommunity";

ClassMethod GetConceptsByID(ID As %Integer, ByRef CList, Flg = 0)
{
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set sourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(domId, ":SQL:"_ID_":"_ID)
	
	set tFilter = $s(0:"", 1:##class(%iKnow.Filters.SourceIdFilter).%New(domId, sourceId))
	
	set blackListId = ##class(%iKnow.Utils.MaintenanceAPI).GetBlackListId(domId, ..#BlackLists)
	
	set tSC = ##class(%iKnow.Queries.EntityAPI).GetTop(.CList, domId, 0, 0, tFilter, 11, 0, 0, 0, blackListId)

	if (Flg = 1)
	{
	 	Quit "OK"
	}

	set result =""
	set i = 0
	while(1)
	{	set i = i + 1
		if $DATA(CList(i))
		{ 
			set result = result_","_$list(CList(i),2)
		}else{
			return result
		}
	}
}

/// Returns the combined sets and concepts by answer ID
ClassMethod GetSetsAndConceptsByID(ID As %Integer)
{
	set st = ..GetConceptsByID(ID, .CList, 1)
	set ^AnswerSets(ID) = ""
	
	set i = 0
	set ^out = 1
	set result =""
	while (1)
	{	
		
		set i=i+1
		if $DATA(CList(i))
		{ 	
			set concept = $list(CList(i),2)
			
			set concept = $tr(concept,",","")
			set concept = $tr(concept,"?","")
			set concept = $tr(concept,"""","")
			
			set flag = 0
			
			for s="&",">","<","###","!","/","\","(",")","+","#;","**"
			{	
				if ($l(concept, s) > 1)
				{
					set flag = 1
					quit
				}
			}
			
			if flag = 1 continue
			
			if concept continue
			
			if ($DATA(^CommunityiKnowSets(concept)))
			{
				set ^out(^CommunityiKnowSets(concept)) = ^CommunityiKnowSets(concept)
			}else 
			{
				set result = result_","_concept
			}

		}else{
			set Sets = ""
			
			while(1) 
			{
				set Sets = $ORDER(^out(Sets))
				if (Sets = "")
				{
					k ^out
					return result
				}
				else 
				{ 
					set ^AnswerSets(ID) = ^AnswerSets(ID)_Sets_","
					set result = result_","_Sets 
				}
			}
		}
	}
}

/// Return Sets by answer ID
ClassMethod GetSetsByID(ID As %Integer) As %String
{
	if $DATA(^AnswerSets(ID))
	{
		return ^AnswerSets(ID)
	}else{
		return "SETS BY ID:"_ID_" DOES NOT EXIST"
	}
}

ClassMethod Update() As %Status
{
	do ##class(Community.iKnow.Utils).CreateDomainIfNotExists(..#DomainName)
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set lister = ##class(%iKnow.Source.SQL.Lister).%New(domId)
	set loader = ##class(%iKnow.Source.Loader).%New(domId)
	
	do ##class(%iKnow.Queries.MetadataAPI).AddField(domId,"ID",,"NUMBER")
	
	set myquery = "SELECT ID, Text FROM Community.Comment"
	
	set meta = $lb("ID")
	set data = $lb("Text")
	set group = "ID"
	set id = "ID"
	
	set tSC = lister.AddListToBatch(myquery, id, group, data, meta)
	do loader.ProcessBatch()
	
	return $$$OK
}

}
