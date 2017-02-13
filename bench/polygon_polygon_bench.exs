defmodule PolygonPolygonBench do
  use Benchfella
  import Topo

  @states Path.join([ "bench", "shapes", "states.json" ])
    |> File.read!
    |> Poison.decode!
    |> Map.fetch!("features")
    |> Enum.map(&(&1["geometry"]))
    |> Enum.map(&Geo.JSON.decode/1)

  @counties Path.join([ "bench", "shapes", "counties.json" ])
    |> File.read!
    |> Poison.decode!
    |> Map.fetch!("features")
    |> Enum.map(&(&1["geometry"]))
    |> Enum.map(&Geo.JSON.decode/1)

  bench "Polygon / Polygon equal" do
    a = "POLYGON((400 70,270 160,450 30,260 160,420 30,250 160,390 30,240 160,370 30,230 160,360 30,230 150,330 50,240 130,330 30,230 130,310 30,220 130,280 30,230 100,270 40,220 110,250 30,210 130,240 30,210 100,220 40,200 90,200 20,190 100,180 30,20 20,180 40,20 30,180 50,20 50,180 60,30 60,180 70,20 70,170 80,80 80,170 90,20 80,180 100,40 100,200 110,60 110,200 120,120 120,190 140,190 140,140 130,200 160,130 150,210 170,130 170,210 180,120 190,220 200,120 200,250 210,120 210,250 220,120 220,250 230,120 240,230 240,120 250,240 260,120 260,240 270,120 270,270 290,120 290,230 300,150 310,250 310,180 320,250 320,200 360,260 330,240 360,280 320,290 370,290 320,320 360,310 320,360 360,310 310,380 340,310 290,390 330,310 280,410 310,310 270,420 280,310 260,430 250,300 250,440 240,300 240,450 230,280 220,440 220,280 210,440 210,300 200,430 190,300 190,440 180,330 180,430 150,320 180,420 130,300 180,410 120,280 180,400 110,280 170,390 90,280 160,400 70))" |> Geo.WKT.decode
    b = "POLYGON((280 170,390 90,280 160,400 70,270 160,450 30,260 160,420 30,250 160,390 30,240 160,370 30,230 160,360 30,230 150,330 50,240 130,330 30,230 130,310 30,220 130,280 30,230 100,270 40,220 110,250 30,210 130,240 30,210 100,220 40,200 90,200 20,190 100,180 30,20 20,180 40,20 30,180 50,20 50,180 60,30 60,180 70,20 70,170 80,80 80,170 90,20 80,180 100,40 100,200 110,60 110,200 120,120 120,190 140,190 140,140 130,200 160,130 150,210 170,130 170,210 180,120 190,220 200,120 200,250 210,120 210,250 220,120 220,250 230,120 240,230 240,120 250,240 260,120 260,240 270,120 270,270 290,120 290,230 300,150 310,250 310,180 320,250 320,200 360,260 330,240 360,280 320,290 370,290 320,320 360,310 320,360 360,310 310,380 340,310 290,390 330,310 280,410 310,310 270,420 280,310 260,430 250,300 250,440 240,300 240,450 230,280 220,440 220,280 210,440 210,300 200,430 190,300 190,440 180,330 180,430 150,320 180,420 130,300 180,410 120,280 180,400 110,280 170))" |> Geo.WKT.decode

    equals? a, b
  end

  bench "Counties in States" do
    [state] = Enum.take_random(@states, 1)
    [county] = Enum.take_random(@counties, 1)
    Topo.intersects?(state, county)
    :ok
  end

  bench "Counties in States with Envelope check" do
    [state] = Enum.take_random(@states, 1)
    [county] = Enum.take_random(@counties, 1)
    case Envelope.intersects?(Envelope.from_geo(state), Envelope.from_geo(county)) do
      true -> Topo.intersects?(state, county)
      false -> false
    end
    :ok
  end
end