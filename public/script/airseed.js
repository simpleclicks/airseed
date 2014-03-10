$(document).ready(function(){

	$.ajax({
		url:"http://localhost:4567/getairports",
		type:"GET",
		dataType:"json",
		success:function(resp){
			//console.log(resp);
			renderMap(resp);
		},
		error:function(error){
			console.log(error);
		}
	});
});

function renderMap(mapData){
	var election = new Datamap({
  scope: 'usa',
  element: document.getElementById('map_airports'),
  geographyConfig: {
   highlightBorderColor: '#bada55',
   popupTemplate: function(geography, data) {
	   	if(data != null ){
	 		return '<div class="hoverinfo">' + geography.properties.name + '<BR/> Airports : ' +  data.airportNumber + ' ';  		
	   	} else {
	   		return '<div class="hoverinfo">' + geography.properties.name + '<BR/> Airports : No Airports found!';
	   	}
    },
    highlightBorderWidth: 3
  },
  fills: {
  'low': '#306596',
  'medium': '#667FAF',
  'high': '#CC4731',
  defaultFill: '#EDDC4E'
},
data: mapData,
done: function(datamap) {
            datamap.svg.selectAll('.datamaps-subunit').on('click', function(geography, data) {
            	console.log(mapData[geography.id].cities);
            	var state = geography.properties.name;
            	var stateDetails = mapData[geography.id].cities;
            	var flightInfo = "";
            	$("#title").html("Flight Details for " + state);
            	var tableHandle = $('#tableFlightInfo');
            	var tableData = "<tr><th>City</th><th>Airport</th><th>Enplanements</th></tr>";
            	var totalEnp = 0;
            	for(var i=0; i < stateDetails.length; i++){
            		flightInfo += "<tr>";
            		flightInfo+= "<td style='font-size: 12;'> "+ stateDetails[i].city + "</td>";
            		flightInfo+= "<td style='font-size: 12;'> "+ stateDetails[i].airport + "</td>";
            		flightInfo+= "<td style='font-size: 12;'> "+ stateDetails[i].enplanements + "</td>";
            		flightInfo+= "</tr>";
            		totalEnp += stateDetails[i].enplanements;
            	}
            	
                tableData += flightInfo;
                tableHandle.html(tableData);
                $('#totalEnp').html("Total Enplanements: "+ totalEnp);
                $("#flightInfoModal").modal('show');
            });
        }
});
election.labels();

}
