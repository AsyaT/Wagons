 using CP;
 
{int} wagons = ...;
{int} shipmentPoint = ... ;
{int} startPoint = ...;

int startPointStartDateWagon[1..wagons] = ...; // время момент старта для каждого вагона

int shippmentStartDate[1..shipmentPoint] = ...; // дата отправления груженого рейса
int shippmentDuration[1..shipmentPoint] = ...;//среднее время в пути по направлению груженого рейса


int emptyTrainShipmentDuration[1..shipmentPoint][ 1.. shipmentPoint] = ...; //длительность порожнего рейса.  -1 = рейс недопустим
int emptyTrainStartDuration [1..startPoint] [ 1.. shipmentPoint] = ...;


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