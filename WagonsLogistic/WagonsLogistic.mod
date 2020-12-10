 using CP;
  execute PARAMS{cp.param.TimeLimit = 2*10;}
 
{int} wagons = ...;
{int} shipmentPoint = ... ;
{int} startPoint = ...;

int startPointStartDateWagon[wagons] = ...; // время момент старта для каждого вагона

int shippmentStartDate[shipmentPoint] = ...; // дата отправления груженого рейса
int shippmentDuration[shipmentPoint] = ...;//среднее время в пути по направлению груженого рейса

int emptyTrainStartDuration [startPoint] [ shipmentPoint] = ...;
int emptyTrainShipmentDuration[shipmentPoint][ shipmentPoint] = ...; //длительность порожнего рейса.  -1 = рейс недопустим



dvar interval Shippment[i in shipmentPoint] optional size shippmentDuration[i] ;

dvar interval EmptyTrainFromStartPont[ j in wagons][i in shippmentPoint] optional size shippmentStartDate[i]-startPointStartDateWagon[j];
dvar interval EmptyTrainBetweenShipment[ j in wagons][i in shippmentPoint][k in shippmentPoint] optional size 
shippmentStartDate[k] - (shippmentStartDate[i] + shippmentDuration[i]);

subject to
{

	forall(i in shipmentPoint)
	  {
	  	  startOf(Shippment[i]) == shippmentStartDate[i];
	  	  endOf(Shippment[i]) == shippmentStartDate[i]+shippmentDuration[i];
	  }

}