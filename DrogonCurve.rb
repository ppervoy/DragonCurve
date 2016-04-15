Point = Struct.new(:x, :y)
Line = Struct.new(:start, :stop)
 
Shoes.app(:title => "Dragon Curve", :width => 1500, :height => 1000, :resizable => true) do
 
  def split_segments(n)
    dir = 1
    @segments = @segments.inject([]) do |new, l|
      a, b, c, d = l.start.x, l.start.y, l.stop.x, l.stop.y
 
      mid_x = a + (c-a)/2.0 - (d-b)/2.0*dir
      mid_y = b + (d-b)/2.0 + (c-a)/2.0*dir
      mid_p = Point.new(mid_x, mid_y)
 
      dir *= -1
      new << Line.new(l.start, mid_p)
      new << Line.new(mid_p, l.stop)
    end
  end
 
  @segments = [Line.new(Point.new(350,350), Point.new(1250,350))]
  8.times do |n|
    split_segments(n)
  end
 
  x01, y01, x02, y02 = -1, -1, -1, -1
  corner = 6.0

  @corner_size = corner

  stack do
    @segments.each do |l|
      if (x01 == -1)
        x01 = l.start.x
        y01 = l.start.y

        x02 = l.start.x + (l.stop.x - l.start.x) / corner * (corner - 1.0)
        y02 = l.start.y + (l.stop.y - l.start.y) / corner * (corner - 1.0)

        line x01, y01, x02, y02
        fill red
        arrow(x01,y01,5)

        x01, y01 = x02, y02
      end

      x02 = l.start.x + (l.stop.x - l.start.x) / corner
      y02 = l.start.y + (l.stop.y - l.start.y) / corner

      strokewidth(1)
      line x01, y01, x02, y02
      x01, y01 = x02, y02

      x02 = l.start.x + (l.stop.x - l.start.x) / corner * (corner - 1.0)
      y02 = l.start.y + (l.stop.y - l.start.y) / corner * (corner - 1.0)

      strokewidth(1)
      line x01, y01, x02, y02
      x01, y01 = x02, y02
    end
  end
end