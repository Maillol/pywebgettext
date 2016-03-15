import tornado.web

class MainHandler(tornado.web.RequestHandler):

    def get(self, people):
        """
        Doesn't extact _("this")
        """
        _ = self.locale.translate
        msg = _("{list} is\nonline",
                "{list} are\nonline",
                len(people))
        self.write(msg.format(people))

    def post(self, name):
        msg = self.locale.translate("{list} is\nonline")
        self.write(msg.format("name"))
