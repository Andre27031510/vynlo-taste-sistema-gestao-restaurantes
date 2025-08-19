'use client'

import { useState, useEffect } from 'react'
import { Star, Quote, ArrowLeft, ArrowRight, Play } from 'lucide-react'

export default function Testimonials() {
  const [currentTestimonial, setCurrentTestimonial] = useState(0)

  const testimonials = [
    {
      name: "Carlos Mendes",
      role: "Proprietário",
      restaurant: "Bistrô Gourmet",
      location: "São Paulo - SP",
      image: "/testimonial-1.jpg",
      rating: 5,
      text: "O Vynlo Taste revolucionou completamente nosso restaurante. Aumentamos nossa receita em 40% no primeiro trimestre e reduzimos o desperdício em 60%. A equipe se adaptou rapidamente e agora não conseguimos mais trabalhar sem ele.",
      metrics: { revenue: "+40%", waste: "-60%", efficiency: "+35%" },
      video: true
    },
    {
      name: "Marina Silva",
      role: "Gerente Operacional",
      restaurant: "Pizzaria Bella Vista",
      location: "Rio de Janeiro - RJ",
      image: "/testimonial-2.jpg",
      rating: 5,
      text: "Impressionante como conseguimos otimizar nossos pedidos de delivery. O sistema integrado nos permitiu atender 3x mais pedidos com a mesma equipe. Os relatórios em tempo real são um diferencial incrível.",
      metrics: { orders: "+300%", time: "-45%", satisfaction: "98%" },
      video: false
    },
    {
      name: "Roberto Oliveira",
      role: "Chef Executivo",
      restaurant: "Rede Sabor & Arte",
      location: "Belo Horizonte - MG",
      image: "/testimonial-3.jpg",
      rating: 5,
      text: "Gerenciar 5 unidades nunca foi tão fácil. O dashboard centralizado me permite acompanhar tudo em tempo real. A análise de ingredientes me ajudou a reduzir custos em 25% mantendo a qualidade.",
      metrics: { cost: "-25%", units: "5", growth: "+50%" },
      video: true
    }
  ]

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTestimonial((prev) => (prev + 1) % testimonials.length)
    }, 8000)
    return () => clearInterval(timer)
  }, [testimonials.length])

  const nextTestimonial = () => {
    setCurrentTestimonial((prev) => (prev + 1) % testimonials.length)
  }

  const prevTestimonial = () => {
    setCurrentTestimonial((prev) => (prev - 1 + testimonials.length) % testimonials.length)
  }

  return (
    <section className="py-24 bg-gradient-to-br from-vynlo-dark via-gray-900 to-black relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute top-20 left-10 w-72 h-72 bg-blue-500/10 rounded-full blur-3xl animate-pulse"></div>
      <div className="absolute bottom-20 right-10 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl animate-pulse delay-1000"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
        {/* Header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center space-x-2 bg-blue-500/10 border border-blue-500/20 rounded-full px-4 py-2 mb-6">
            <Star className="w-4 h-4 text-yellow-400 fill-current" />
            <span className="text-blue-400 font-manrope font-medium text-sm">
              Depoimentos Reais
            </span>
          </div>
          
          <h2 className="text-5xl lg:text-6xl font-manrope font-bold text-white mb-6">
            Histórias de
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-purple-500">
              sucesso
            </span>
          </h2>
          
          <p className="text-xl text-gray-300 font-manrope max-w-3xl mx-auto">
            Veja como restaurantes reais transformaram seus negócios com o Vynlo Taste
          </p>
        </div>

        {/* Main Testimonial */}
        <div className="relative">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            
            {/* Testimonial Content */}
            <div className="space-y-8 animate-fade-in">
              {/* Quote */}
              <div className="relative">
                <Quote className="w-16 h-16 text-blue-400/30 absolute -top-4 -left-4" />
                <blockquote className="text-2xl lg:text-3xl font-manrope text-white leading-relaxed relative z-10">
                  "{testimonials[currentTestimonial].text}"
                </blockquote>
              </div>

              {/* Author Info */}
              <div className="flex items-center space-x-4">
                <div className="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
                  <span className="text-white font-manrope font-bold text-xl">
                    {testimonials[currentTestimonial].name.charAt(0)}
                  </span>
                </div>
                
                <div>
                  <div className="text-xl font-manrope font-bold text-white">
                    {testimonials[currentTestimonial].name}
                  </div>
                  <div className="text-blue-400 font-manrope">
                    {testimonials[currentTestimonial].role}
                  </div>
                  <div className="text-gray-400 font-manrope text-sm">
                    {testimonials[currentTestimonial].restaurant} • {testimonials[currentTestimonial].location}
                  </div>
                </div>
              </div>

              {/* Rating */}
              <div className="flex items-center space-x-2">
                {[...Array(testimonials[currentTestimonial].rating)].map((_, i) => (
                  <Star key={i} className="w-6 h-6 text-yellow-400 fill-current" />
                ))}
                <span className="text-gray-300 font-manrope ml-2">
                  {testimonials[currentTestimonial].rating}.0/5.0
                </span>
              </div>
            </div>

            {/* Metrics Cards */}
            <div className="space-y-6">
              {Object.entries(testimonials[currentTestimonial].metrics).map(([key, value], index) => {
                const labels = {
                  revenue: 'Aumento na Receita',
                  waste: 'Redução de Desperdício', 
                  efficiency: 'Melhoria na Eficiência',
                  orders: 'Aumento em Pedidos',
                  time: 'Redução no Tempo',
                  satisfaction: 'Satisfação do Cliente',
                  cost: 'Redução de Custos',
                  units: 'Unidades Gerenciadas',
                  growth: 'Crescimento'
                }
                
                return (
                  <div 
                    key={key}
                    className="group bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-gray-700 hover:border-blue-500/50 transition-all duration-300 transform hover:scale-105 hover:-translate-y-2"
                    style={{ animationDelay: `${index * 0.1}s` }}
                  >
                    <div className="flex items-center justify-between">
                      <div>
                        <div className="text-3xl font-manrope font-bold text-white mb-1">
                          {value}
                        </div>
                        <div className="text-gray-300 font-manrope text-sm">
                          {labels[key as keyof typeof labels]}
                        </div>
                      </div>
                      
                      <div className="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-500 rounded-xl flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <Star className="w-6 h-6 text-white" />
                      </div>
                    </div>
                  </div>
                )
              })}

              {/* Video Button */}
              {testimonials[currentTestimonial].video && (
                <button className="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-manrope font-semibold px-6 py-4 rounded-xl transition-all duration-300 transform hover:scale-105 flex items-center justify-center space-x-2">
                  <Play className="w-5 h-5" />
                  <span>Assistir Depoimento Completo</span>
                </button>
              )}
            </div>
          </div>

          {/* Navigation */}
          <div className="flex items-center justify-between mt-12">
            <button
              onClick={prevTestimonial}
              className="w-12 h-12 bg-white/10 hover:bg-white/20 border border-gray-700 hover:border-blue-500 rounded-full flex items-center justify-center text-white transition-all duration-300 transform hover:scale-110"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>

            {/* Indicators */}
            <div className="flex space-x-2">
              {testimonials.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentTestimonial(index)}
                  className={`w-3 h-3 rounded-full transition-all duration-300 ${
                    index === currentTestimonial 
                      ? 'bg-blue-500 w-8' 
                      : 'bg-gray-600 hover:bg-gray-500'
                  }`}
                />
              ))}
            </div>

            <button
              onClick={nextTestimonial}
              className="w-12 h-12 bg-white/10 hover:bg-white/20 border border-gray-700 hover:border-blue-500 rounded-full flex items-center justify-center text-white transition-all duration-300 transform hover:scale-110"
            >
              <ArrowRight className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Bottom CTA */}
        <div className="text-center mt-20">
          <div className="bg-gradient-to-r from-blue-600/20 to-purple-600/20 backdrop-blur-sm border border-blue-500/30 rounded-3xl p-12">
            <h3 className="text-3xl font-manrope font-bold text-white mb-4">
              Pronto para ser o próximo caso de sucesso?
            </h3>
            <p className="text-xl font-manrope text-gray-300 mb-8">
              Junte-se a centenas de restaurantes que já transformaram seus negócios
            </p>
            <button className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-manrope font-bold px-8 py-4 rounded-xl transition-all duration-300 transform hover:scale-105">
              Começar Minha Transformação
            </button>
          </div>
        </div>
      </div>
    </section>
  )
}