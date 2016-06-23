__author__ = 'shaunomeara'

from lxml import etree

class lvxml():

#    def __init__(self, conf):
#        self.debug = False
#        self.config = conf['nodes']


    def _networks(self):
        """
        Serialise network output
        :return:
        """

    def _disks(self):
        """
        Serialise disks
        :return:
        """

    def _root_domain(self):
        """
        Serialise basic domain details
        :return:
        """
        root = etree.Element('Domain', type='kvm', id='')

        return root


    def _attrib(self, data, root):

        for obj in data:
            #print obj, data[obj]['text'], data[obj]['element']
            dombase = etree.Element(obj, data[obj]['element'])
            if data[obj]['text']:
                dombase.text = data[obj]['text']
            root.append(dombase)
        return root

    def _section(self, sec_name, data, root):


        section = etree.Element(sec_name)
        for obj in data:
            #print obj, data[obj]['text'], data[obj]['element']
            dombase = etree.Element(obj, data[obj]['element'])
            if data[obj]['text']:
                dombase.text = data[obj]['text']
            section.append(dombase)

        root.append(section)
        return root


    def build(self):

        root = self._root_domain()

        data = {
                'memory':{'text':'','element':{'unit':'kib'}},
                'currentMemory':{'text':'','element':{'unit':'kib'}},
                'name':{'text':'node1','element':{}},
                'vcpu':{'text':'','element':{'placement':'static'}}
                   }
        self._attrib(data, root)

        data = {
                'type':{'text':'hvm','element':{'arch':'x86_64', 'machine':'pc-i440fx-trusty'}},
                'boot':{'text':'','element':{'dev':'network'}},
                'boot':{'text':'','element':{'dev':'hd'}}
                   }
        self._section('os',data,root)

        s = etree.tostring(root, pretty_print=True)
        print s

        return root


def main():

    lvx = lvxml()
    lvx.build()


if __name__== "__main__":
    main()
