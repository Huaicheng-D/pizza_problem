import sys
import os
import random as r

if __name__ == "__main__":
    if (len(sys.argv) < 3):
        number_of_files = 5
        n = r.randint(1, 40)
        m = r.randint(1, 20)
    else:
        n = int(sys.argv[1])
        m = int(sys.argv[2])
        number_of_files = int(sys.argv[3])

    for i in range(0, number_of_files):
        output = ("data" + str(i+1) + ".dzn")
        if os.path.exists("data_instances/" + output):
            os.remove("data_instances/" + output)
        f = open("data_instances/"+output, "a")

        f.write("n = " + str(n) + ";" + "\n")
        f.write("m = " + str(m) + ";" + "\n")

        price = []
        buy = []
        free = []

        for j in (range(0, n)):
            price.append(r.randint(5, 100))

        for k in (range(0, m)):
            buy.append(r.randint(1, 5))

        for x in range(0, m):
            free.append(r.randint(1, 4))

        f.write("price = [")

        for p in range(0, len(price)):
            if p == (len(price) - 1):
                f.write(str(price[p]) + "];\n")
            else:
                f.write(str(price[p]) + ",")

        f.write("buy = [")
        for b in range(0, len(buy)):
            if b == (len(buy) - 1):
                f.write(str(buy[b]) + "];\n")
            else:
                f.write(str(buy[b]) + ",")

        f.write("free = [")
        for F in range(0, len(free)):
            if F == (len(free) - 1):
                f.write(str(free[F]) + "];\n")
            else:
                f.write(str(free[F]) + ",")
        
        maximum_cost = sum(price)
        k = r.randint(int(maximum_cost/2), maximum_cost + 1)
        f.write("k = " + str(k) + ";\n")

        f.close()




