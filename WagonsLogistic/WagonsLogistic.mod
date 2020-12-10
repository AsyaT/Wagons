 using CP;
  execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} wagons = ...;
{int} shipmentPoint = ... ;
{int} startPoint = ...;

int startPointStartDateWagon[wagons] = ...; // время момент старта для каждого вагона
int pointOfStart[wagons] = ...;

int shippmentStartDate[shipmentPoint] = ...; // дата отправления груженого рейса
int shippmentDuration[shipmentPoint] = ...;//среднее время в пути по направлению груженого рейса

int emptyTrainStartDuration [startPoint] [ shipmentPoint] = ...;
int emptyTrainShipmentDuration[shipmentPoint][ shipmentPoint] = ...; //длительность порожнего рейса.  -1 = рейс недопустим



dvar interval Shippment[sp in shipmentPoint] optional size shippmentDuration[sp] ;

dvar interval EmptyTrainFromStartPont[w in wagons][sp in startPoint] optional size shippmentStartDate[sp]-startPointStartDateWagon[w];
dvar interval EmptyTrainBetweenShipment[w in wagons][sp1 in shipmentPoint][sp2 in shipmentPoint] optional size 
shippmentStartDate[sp1] - (shippmentStartDate[sp2] + shippmentDuration[sp2]);

dvar sequence WagonSequence[w in wagons] in append 
(
	all(i in startPoint) EmptyTrainFromStartPont[w][i],
	all(sp in shipmentPoint) Shippment[sp],
	all(sp1 in shipmentPoint, sp2 in shipmentPoint) EmptyTrainBetweenShipment[w][sp1][sp2]
)
types
append (0, 1, 2);

maximize 1;

subject to
{

	

	forall(i in shipmentPoint)
	  {
	  	  startOf(Shippment[i]) == shippmentStartDate[i];
	  	  endOf(Shippment[i]) == shippmentStartDate[i]+shippmentDuration[i];
	  }

	forall(w in wagons)
	  {
	  
	  	noOverlap(WagonSequence[w]);
	  	  
	  
		  forall(i in startPoint)
		    {	  
		  		startOf ( EmptyTrainFromStartPont [w][i]) >= startPointStartDateWagon[w];
		  	}
		  	
		  forall(sp in startPoint)	
		  	{	
		  		first(WagonSequence[w], EmptyTrainFromStartPont[w][sp]);
  			}		  
	  }
}