# Mendix powered RAG
The goal of this project is to build a RAG (Retrieval Augmented Generation) pipeline from scratch and have it run on AWS.

Specifically, we'd like to be able to open a set of files (PDF, docx,...), ask questions (queries) about them, and have them answered by a large language model (LLM).

## What is RAG?
RAG stands for Retrieval Augmented Generation.

It was introduced in the paper [Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks](https://arxiv.org/abs/2005.11401).

Each step can be roughly broken down into:

+ **Retrieval** —Seeking relevant information from a source given a query, such as getting relevant passages of Wikipedia text from a database given a question.
+ **Augmented** - Using the relevant retrieved information to modify an input to a generative model (e.g. an LLM).
+ **Generation** - Generating an output given an input. For example, in the case of an LLM, generating a passage of text is given an input prompt.

## Why a RAG?
The main goal of RAG is to improve the generation outputs of LLMs.

Two primary improvements can be seen as:

1. **Preventing hallucinations**—LLMs are incredible, but they are prone to potential hallucinations, as in generating something that looks correct but isn't. RAG pipelines can help LLMs generate more factual outputs by providing them with factual (retrieved) inputs. And even if the generated answer from an RAG pipeline doesn't seem correct, because of retrieval, you also have access to the sources from which it came.
2. **Work with custom data**—Many base LLMs are trained with internet-scale text data. This means they have a great ability to model language; however, they often lack specific knowledge. RAG systems can provide LLMs with domain-specific data, such as medical information or company documentation, and thus customize their outputs to suit specific use cases.
The authors of the original RAG paper mentioned above outlined these two points in their discussion.

This work offers several positive societal benefits over previous work: the fact that it is more firmly grounded in actual factual knowledge (in this case, Wikipedia) makes it “hallucinate” less with more factual generations and offers more control and interpretability. RAG could be employed in a wide variety of scenarios with direct benefit to society, for example, by endowing it with a medical index and asking it open-domain questions on that topic, or by helping people be more effective at their jobs.

RAG can also be a much quicker solution than fine-tuning an LLM on specific data.

## What kind of problems can RAG be used for?
RAG can help anywhere there is a specific set of information that an LLM may not have in its training data (e.g. anything not publicly accessible on the internet).

For example, you could use RAG for:

+ **Customer support Q&A chat** - By treating your existing customer support documentation as a resource, when a customer asks a question, you could have a system retrieve relevant documentation snippets and then have an LLM craft those snippets into an answer. Think of this as a "chatbot for your documentation". Klarna, a large financial company, uses a system like this to save $40M per year on customer support costs.
Email chain analysis - Let's say you're an insurance company with long threads of emails between customers and insurance agents. Instead of searching through each individual email, you could retrieve relevant passages and have an LLM create structured outputs of insurance claims.
+ **Company internal documentation chat** - If you've worked at a large company, you know how hard it can sometimes be to get an answer. Why not let an RAG system index your company information and have an LLM answer questions you may have? The benefit of RAG is that you will have references to resources to learn more if the LLM answer doesn't suffice.
+ **Textbook Q&A** - Let's say you're studying for your exams and constantly flicking through a large textbook looking for answers to your questions. RAG can help provide answers as well as references to learn more.

All of these have the common theme of retrieving relevant resources and then understandably presenting them using an LLM.

From this angle, you can consider an LLM a calculator for words.

## Key terms

| Term | Description |
| ----- | ----- | 
| **Token** | A sub-word piece of text. For example, "hello, world!" could be split into ["hello", ",", "world", "!"]. A token can be a whole word, part of a word or a group of punctuation characters. 1 token ~= 4 characters in English, 100 tokens ~= 75 words. Text gets broken into tokens before being passed to an LLM. |
| **Embedding** | A learned numerical representation of a piece of data. For example, a sentence of text could be represented by a vector with 768 values. Similar pieces of text (in meaning) will ideally have similar values. |
| **Embedding model** | A model designed to accept input data and output a numerical representation. For example, a text embedding model may take in 384 tokens of text and turn it into a vector of size 768. An embedding model can and often is different to an LLM model. |
| **Similarity search/vector search** | Similarity search/vector search aims to find two vectors that are close together in a high-dimensional space. For example, two pieces of similar text passed through an embedding model should have a high similarity score, whereas two pieces about different topics will have a lower similarity score. Common similarity score measures are dot product and cosine similarity. |
| **Large Language Model (LLM)** | A model trained to numerically represent the patterns in text. A generative LLM will continue a sequence when given a sequence. For example, given a sequence of the text "hello, world!", a generative LLM may produce "we're going to build a RAG pipeline today!". This generation will be highly dependent on the training data and prompt. |
| **LLM context window** | The number of tokens a LLM can accept as input. For example, as of March 2024, GPT-4 has a default context window of 32k tokens (about 96 pages of text) but can go up to 128k if needed. A recent open-source LLM from Google, Gemma (March 2024), has a context window of 8,192 tokens (about 24 pages of text). A higher context window means an LLM can accept more relevant information to assist with a query. For example, in an RAG pipeline, a model with a larger context window can accept more reference items from the retrieval system to aid its generation. |
| **Prompt** | A common term for describing the input to a generative LLM. The idea of "[prompt engineering](https://en.wikipedia.org/wiki/Prompt_engineering)" is to structure a text-based (or potentially image-based as well) input to a generative LLM in a specific way so that the generated output is ideal. This technique is possible because of an LLM's capacity for in-context learning, as in, it can use its representation of language to break down the prompt and recognize what a suitable output may be (note: the output of LLMs is probable, so terms like "may output" are used). | 

