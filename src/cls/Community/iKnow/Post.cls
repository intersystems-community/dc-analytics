Include %IKPublic

Class Community.iKnow.Post
{

Parameter DomainName As STRING = "CommunityPost";

Parameter BlackLists As STRING = "BLcommunity";

Parameter FilterForChars As STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789^&$%:#.,- éÉ";

ClassMethod GetConceptsByID(ID As %Integer, ByRef CList, Flg = 0) As %String
{
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set sourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(domId, ":SQL:"_ID_":"_ID)
	
	set tFilter = ##class(%iKnow.Filters.SourceIdFilter).%New(domId, sourceId)
	
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

/// Return combined Sets and concepts by answer ID
ClassMethod GetFirstSetsAndConceptsByID(ID As %Integer) As %String
{
	set st = ..GetConceptsByID(ID, .CList, 1)
	set ^PostSets(ID) = ""
	
	set i = 0
	set out = 1
	set result =""
	while (1)
	{	
		
		set i=i+1
		if $DATA(CList(i))
		{ 	
			set flag = 0
			set concept = $list(CList(i),2)
			
			set concept = $tr(concept,",?""","")
			
			if concept continue
			if $L(concept," ")>1 continue
			
			if ($tr(concept,..#FilterForChars) '="") continue

			for s="&",">","<","###","!","/","\","(",")","+","#;","**","--"
			{	
				if (($l(concept, s) > 1) || ($l(concept)>100))
				{
					set flag = 1
					quit
				}
			}
			
			if (flag = 1) continue
			
			if ($DATA(^CommunityiKnowSets(concept)))
			{
				set out(^CommunityiKnowSets(concept)) = ^CommunityiKnowSets(concept)
			}else 
			{
				set result = result_","_concept
			}

		}else{
			set Sets = ""
			
			while(1) 
			{
				set Sets = $ORDER(out(Sets))
				if (Sets = "")
				{
					k out
					return result
				}
				else 
				{ 
					set ^PostSets(ID) = ^PostSets(ID)_Sets_","
					set result = result_","_Sets 
				}
			}
		}
	}
}

/// Return Sets by answer ID
ClassMethod GetSetsByID(ID As %Integer) As %String
{
	if $DATA(^PostSets(ID))
	{
		return ^PostSets(ID)
	}else{
		return "SETS BY ID:"_ID_" DOES NOT EXIST"
	}
}

ClassMethod Update() As %Status
{
	do ##class(Community.iKnow.Utils).CreateDomainIfNotExists(..#DomainName)
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set tSC = ##class(%iKnow.Domain).%OpenId(domId).DropData(1, 1, 1, 0, 1)
	
	set lister = ##class(%iKnow.Source.SQL.Lister).%New(domId)
	set loader = ##class(%iKnow.Source.Loader).%New(domId)
	
	do ##class(%iKnow.Queries.MetadataAPI).AddField(domId,"ID",,"NUMBER")
	
	set myquery = "SELECT ID, Text FROM Community.Post"
	
	set meta = $lb("ID")
	set data = $lb("Text")
	set group = "ID"
	set id = "ID"
	
	set tSC = lister.AddListToBatch(myquery, id, group, data, meta)
	do loader.ProcessBatch()
	
	return "OK"
}

}

