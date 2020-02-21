class MyFlow(Flowspec):
@step #Python装饰器写法
def start(self)
    self.data=load_data()
    self.next(self.fitA, self.fitB)

@ step
def fiA(self)
    self.fit(self.data, model='A')
    self.next(self.eval)

@step
def fitB(self)
    self.fit(self.data, model='B')
    self.next(self.eval)

@step
def eval(self, inputs)
    self.best=max((i.model.score,i.model)
    for i in inputs)[1]
self. next(self, end)

@step
def end ( self)
    print(done!')
