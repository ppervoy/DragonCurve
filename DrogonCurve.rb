Point = Struct.new(:x, :y)
Line = Struct.new(:start, :stop)

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

foldcount = 0
totalfolds = 12
 
Shoes.app(:title => "Dragon Curve", :width => 1200, :height => 800, :resizable => true) do 
  @animate = animate (3) do |frame|
    clear do
      if foldcount == totalfolds
        @animate.stop
      end
      
      @segments = [Line.new(Point.new(325,275), Point.new(1025,275))]
      foldcount.times do |n|
        split_segments(n)
      end

      foldcount += 1
      
      x01, y01, x02, y02 = -1, -1, -1, -1
      corner = 18.0 - foldcount
      pathwidth = 0.5
      turncount = 0
      pathchunk = 8
      showchunks = false
      arrowsize = 20

      strokewidth(pathwidth)

      stack do
        @segments.each do |l|
          if (x01 == -1)
            x01 = l.start.x
            y01 = l.start.y

            x02 = l.start.x + (l.stop.x - l.start.x) / corner * (corner - 1.0)
            y02 = l.start.y + (l.stop.y - l.start.y) / corner * (corner - 1.0)

            line x01, y01, x02, y02
            strokewidth(0)
            fill green
            #rotation = foldcount * -45 + 135
            #rotate -90
            #arrow(x01, y01, arrowsize)
            #rotate 90
            strokewidth(pathwidth)

            x01, y01 = x02, y02

            turncount += 1
          else
            x02 = l.start.x + (l.stop.x - l.start.x) / corner
            y02 = l.start.y + (l.stop.y - l.start.y) / corner

            line x01, y01, x02, y02
            x01, y01 = x02, y02

            x02 = l.start.x + (l.stop.x - l.start.x) / corner * (corner - 1.0)
            y02 = l.start.y + (l.stop.y - l.start.y) / corner * (corner - 1.0)

            line x01, y01, x02, y02
            x01, y01 = x02, y02

            if (turncount == pathchunk - 1)
              fill blue
              strokewidth(0)
              if showchunks 
                oval(x01 - 3, y01 - 3, corner)
              end
              strokewidth(pathwidth)
              turncount = 0
            else
              turncount += 1
            end
          end
        end
      end
    end
  end
end