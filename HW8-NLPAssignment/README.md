# NLP 模型的使用

---

## 1. 作业要求

结合提供的NLP模型，在starter的基础上实现文本情绪分类、文本翻译、文本关键信息提取的功能。

### 1.1 模型训练

notebook目录下提供了用于训练NLP模型的代码和数据。你可以根据环境配置文件安装环境自己进行训练。但是训练过程较长，因此在notebook/pre-trained中提供了可以直接使用的模型。包括用于情绪预测的SentimentClassifier.mlmodel和用于翻译的Encoder和Decoder以及用于编码和解码的JSON文件。可以通过阅读Xcode中的说明来理解每个模型的功能。

### 1.2 情绪判断

你需要针对每个Review，使用模型SentimentClassifer预测它的情绪，并使用合适的Emoji来标记。

### 1.3 文本关键信息提取

对于每一个Review，你需要从中提取出两个信息，包括人名、语言、关键字(分别对应NLPHelper的getPeopleNames, getLanguage和getSearchTerms)。并在Tab Bar 的By Actor和By Language的两个Tab中使用你提取出的人名和语言对所有Review进行分类展示。以及在搜索栏中实现根据用户输入显示相关的Reviews的功能。

文本关键信息提取可以使用苹果官方提供的NaturalLanguage框架中的[NLTagger](https://developer.apple.com/documentation/naturallanguage/nltagger)来实现。

### 1.4 文本翻译

文本翻译的过程比较复杂，我们提供了用于在Int和Char之间进行转换的两个JSON文件，首先需要将待翻译的文本根据JSON文件编码成Int序列。然后分别使用Encoder和Decoder两个模型（根据设备的性能，选择32bit版本和16bit版本的模型），得到翻译后的Int序列，再根据JSON文件将Int序列转换成文本。我们提供的模型可以将西班牙语翻译为英语，如果你检测到西班牙语，需要给出它的英语翻译。



## 目标效果

- 翻译和情感分类

<img src="./images/final-1.png" alt="image" style="zoom:50%;" />

- 按照关键信息进行分类

<img src="./images/final-2.png" alt="image" style="zoom:50%;" />



- 关键词搜索功能

  <img src="images/final-3.png" alt="image" style="zoom:50%;" />

### 



 

