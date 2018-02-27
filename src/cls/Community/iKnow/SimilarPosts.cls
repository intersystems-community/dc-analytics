Include %IKPublic

Class Community.iKnow.SimilarPosts [ DependsOn = Community.Post ]
{

Parameter DomainName As STRING = "SimilarPosts";

ClassMethod GetSimilarPostsByPostID(ID As %Integer, count As %Integer = 5, flag As %String = "Id") As %List
{
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set sourceId = ##class(%iKnow.Queries.SourceAPI).GetSourceId(domId, ":SQL:"_ID_":"_ID)
	
	set tSC = ##class(%iKnow.Queries.SourceAPI).GetSimilar(.CList, domId, sourceId,, count)

	#dim result As %DynamicArray = []

	set key = $ORDER(CList(""))
	
	while(key'="")
	{	
		set id = $P($List(CList(key), 2), ":", *)
		if (flag = "Id")
		{
			do result.%Push(id)
		}else
		{
			set link = ##class(%iKnow.Queries.MetadataAPI).GetValue(domId, "Link", ":SQL:"_id_":"_id)
			do result.%Push(link)
		}
		set key=$ORDER(CList(key))
	}
	
	return result
}

ClassMethod GetSimilarTextByPostID(ID As %Integer, count As %Integer = 5, ByRef ids) As %Status
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

/// do ##class(Community.iKnow.SimilarPosts).Update()
ClassMethod Update() As %Status
{
	set tSC = $$$OK
	do ##class(Community.iKnow.Utils).CreateDomainIfNotExists(..#DomainName)
	set domId  = ##class(%iKnow.Domain).GetOrCreateId(..#DomainName)

	set tSC = ##class(%iKnow.Domain).%OpenId(domId).DropData(1, 1, 1, 1, 1)
	
	set lister = ##class(%iKnow.Source.SQL.Lister).%New(domId)
	set loader = ##class(%iKnow.Source.Loader).%New(domId)
	
	set val=##class(%iKnow.Queries.MetadataAPI).AddField(domId,"Link",,$$$MDDTSTRING)
	set val=##class(%iKnow.Queries.MetadataAPI).AddField(domId,"ID",,$$$MDDTNUMBER)

	set query = "SELECT ID, Text, Link FROM Community.Post"
	set meta = $lb("Link","ID")
	set data = $lb("Text")
	set group = "ID"
	set id = "ID"
	
	set tSC = lister.AddListToBatch(query, id, group, data, meta)
	w "Process add post in iKnow. Please wait...",!
	set tSC = loader.ProcessBatch()
	w "Done!"
	return tSC
}

}

