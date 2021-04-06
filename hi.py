import tkinter as tk

root = tk.Tk()
root.title("Hello World!")
can = tk.Canvas(root, bg="red")
can.create_text(100, 100, text="Hi")
can.create_rectangle(50,50,150,200)
can.pack()
btn = tk.Button(root, text="Hello", command=(lambda: print("Click")))
btn.pack()
root.mainloop()
