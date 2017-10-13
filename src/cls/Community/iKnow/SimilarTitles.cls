Include %IKPublic

Class Community.iKnow.SimilarTitles
{

Parameter DomainName As STRING = "SimilarTitles";

ClassMethod GetSimilarTitlesByPostID(ID As %Integer, count As %Integer = 5, ByRef ids) As %Status
{
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set sourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(domId, ":SQL:"_ID_":"_ID)
	
	set tSC = ##class(%iKnow.Queries.SourceAPI).GetSimilar(.CList, domId, sourceId,, count)

	set key = $ORDER(CList(""))
	
	while(key'="")
	{	
		set similarity = $List(CList(key), 3)
		
		set ids($P($ListGet(CList(key), 2),":",*)) = similarity
	
		set key=$ORDER(CList(key))
	}
	
	return tSC
}

/// do ##class(Community.iKnow.SimilarTitles).Update()
ClassMethod Update() As %Status
{
	set tSC = $$$OK
	do ##class(Community.iKnow.Utils).CreateDomainIfNotExists(..#DomainName)
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set tSC = ##class(%iKnow.Domain).%OpenId(domId).DropData(1, 1, 1, 1, 1)
	
	set lister = ##class(%iKnow.Source.SQL.Lister).%New(domId)
	set loader = ##class(%iKnow.Source.Loader).%New(domId)

	set query = "SELECT ID, Name FROM Community.Post"
	set data = $lb("Name")
	set group = "ID"
	set id = "ID"
	
	set tSC = lister.AddListToBatch(query, id, group, data)
	w "Process add title in iKnow. Please wait...",!
	set tSC = loader.ProcessBatch()
	w "Done!"
	return tSC
}

}

